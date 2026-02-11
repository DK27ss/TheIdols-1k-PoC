# MarketplaceRefundContract Exploit - VIRTUE Theft via `claimVirtueRefund`

## Summary

| Field | Value |
|---|---|
| **Protocol** | TheIdols NFT (Marketplace Refund) |
| **Chain** | Ethereum |
| **Exploited Contract** | `MarketplaceRefundContract` - `0x87d2EdBA911c7E2E13580af897bA77E47e8B8c8B` |
| **Token** | VIRTUE (`0x9416bA76e88D873050A06e5956A3EBF10386b863`) |
| **Amount** | ~968.52 VIRTUE (`968,517,168,940,900,914,046 wei`) |
| **Attacker (contract)** | `0xE20151AF6F3BA0f7a2FD89B3A98Cb9C50768Ce16` |

-----

| Contract | Address |
|---|---|
| IdolMintContract | `0x7B4b02372d8e54c1C0454D97F01D85eF203cdC5e` |
| IdolMarketplace | `0x0dD5A35fe4cd65FE7928c7b923902b43d6ea29E7` |
| IdolMain | `0x439cac149b935ae1d726569800972e1669d17094` |
| VirtueToken | `0x9416ba76e88d873050a06e5956a3ebf10386b863` |
| MarketplaceRefundContract | `0x87d2edba911c7e2e13580af897ba77e47e8b8c8b` |
| OfferingRefundContract | `0x2e94c074d7360dccf0d7b2891d867b734978e8ad` |

---

## Root cause

The `MarketplaceRefundContract` contained a critical vulnerability in the `claimVirtueRefund` function (line 83): VIRTUE tokens were sent to `msg.sender` (the transaction caller) instead of `_to` (the legitimate beneficiary verified by the Merkle proof). An attacker exploited this flaw by calling the function 20 times within a single transaction, impersonating 20 different legitimate beneficiaries, and redirecting all of their VIRTUE refunds to their own address.

---

## Merkle Tree Reconstruction

Exploiting the `msg.sender` bug requires knowledge of each victim's leaf data (`address`, `refundAmount`) and a valid Merkle proof. The Merkle tree was never published off-chain, but the attacker was able to **reconstruct it almost entirely from public on-chain data**.

### Phase 1 - Harvesting known leaves (~85% of the tree)

Only **426 transactions** had ever called `claimVirtueRefund` on this contract. Each of these transactions contained the full calldata in cleartext:

- `_to` (the beneficiary address)
- `_refundAmount` (the VIRTUE amount)
- `_merkleProof` (the full array of sibling hashes)

Since the leaf is computed as `keccak256(abi.encodePacked(_to, _refundAmount))`, the attacker could recompute every leaf from the 426 past successful claims. The Merkle proofs included in each transaction also exposed all intermediate sibling nodes along each path from leaf to root, allowing the attacker to **reconstruct over 85% of the Merkle tree structure** - internal nodes included.

### Phase 2 - Bruteforcing the 20 remaining leaves

With the tree nearly complete, only **20 leaves remained unknown** - corresponding to the 20 addresses that had never claimed. The attacker identified these missing positions by looking for gaps in the reconstructed tree (nodes whose sibling was known from proofs but whose own preimage was not).

To fill these gaps, the attacker:

1. **Collected the fund source amounts** for each address that had interacted with the original marketplace contract (the `IdolMarketplace` at `0x0dD5A35fe...`). These are the historical deposit/purchase amounts that determined each user's refund entitlement.
2. **Recomputed candidate refund amounts** from these source-of-funds values, using the same refund calculation logic the team used to build the original tree.
3. **For each candidate `(address, amount)` pair**, computed `keccak256(abi.encodePacked(address, amount))` and checked whether the resulting leaf hash matched one of the 20 unknown positions in the partially reconstructed tree.
4. **Validated each candidate** by assembling a full Merkle proof from the known sibling nodes and verifying it against the on-chain `merkleRootVirtue`.

This approach was feasible because:
- The set of candidate addresses was small (only marketplace users who had not yet claimed).
- The refund amounts were deterministic, derived from on-chain marketplace activity.
- The tree was small enough (a few hundred leaves) that the brute-force search space was trivial.

### Result

The attacker obtained all 20 valid `(address, refundAmount, merkleProof)` tuples and used them in a single atomic transaction to drain every unclaimed VIRTUE refund.

---

## Details

- **File**: `MarketplaceRefundContract.sol`
- **Function**: `claimVirtueRefund` (lines 74-84)

```solidity
function claimVirtueRefund(
    address _to,
    uint _refundAmount,
    bytes32[] calldata _merkleProof
) external {
    require(!alreadyClaimedVirtue[_to], "Refund has already been claimed for this address");

    // Verify against the Merkle tree that the transaction is authenticated for the user.
    bytes32 leaf = keccak256(abi.encodePacked(_to, _refundAmount));
    require(MerkleProof.verify(_merkleProof, merkleRootVirtue, leaf), "Failed to authenticate with merkle tree");

    alreadyClaimedVirtue[_to] = true;

    virtueToken.transfer(msg.sender, _refundAmount); // <-- BUG: sends to msg.sender, not _to
}
```

The function logic presents a **critical inconsistency between verification and execution**:

1. **Verification** (lines 75-79): The Merkle proof validates that address `_to` is entitled to `_refundAmount` VIRTUE tokens. This is correct.
2. **State Update** (line 81): Address `_to` is marked as having already claimed. This is correct.
3. **Transfer** (line 83): Tokens are sent to **`msg.sender`** instead of **`_to`**. **This is the bug.**

This means **anyone** can call this function with a legitimate beneficiary address, provide their valid Merkle proof, and receive the tokens in their place. As described in the [Merkle Tree Reconstruction](#merkle-tree-reconstruction) section above, the attacker obtained these proofs by reconstructing the tree from 426 past on-chain claims and brute-forcing the 20 remaining unknown leaves.

---

The attacker executed a **single transaction** containing 20 successive calls to `claimVirtueRefund` via an attack contract deployed at `0xE20151AF6F3BA0f7a2FD89B3A98Cb9C50768Ce16`.

```
Attacker (EOA)
    |
    v
Attack Contract (0xE201...Ce16)
    |
    |-- claimVirtueRefund(victim_1, amount_1, proof_1)   --> VIRTUE sent to 0xE201
    |-- claimVirtueRefund(victim_2, amount_2, proof_2)   --> VIRTUE sent to 0xE201
    |-- ...
    |-- claimVirtueRefund(victim_20, amount_20, proof_20) --> VIRTUE sent to 0xE201
    |
    |-- balanceOf(0xE201) --> 968,517,168,940,900,914,046
    |-- transfer(0x622B...feAf, 968,517,168,940,900,914,046)  --> Exfiltration
```

| # | Victim Address (`_to`) | VIRTUE Amount (wei) | VIRTUE Amount |
|---|---|---|---|
| 1 | `0xd8856cCe3F878d3Ea03964F80B18987fF1919272` | 425,603,926,445,278,314,908 | ~425.60 |
| 2 | `0x4f522cbCC4E1Fa79440D0292a5cD7507d1F8987F` | 114,124,275,237,999,999,772 | ~114.12 |
| 3 | `0x0F9722e3C05d072b74eecA56CB1AA333100B1184` | 114,124,275,237,999,999,772 | ~114.12 |
| 4 | `0xb87Ebf06f8C99F43ecad940e4F1ACe84EECE776b` | 102,711,847,714,200,000,001 | ~102.71 |
| 5 | `0xe1B8884110B1eD28E380fFbe5BD16d315AE9712B` | 57,062,137,618,999,999,772 | ~57.06 |
| 6 | `0x58a9ABbc6355490a50EED6a159D8f5F2159e7E30` | 56,583,137,603,746,674,750 | ~56.58 |
| 7 | `0x63F0a3660170A5c9cd4CA7b28B82f0011FFB37C4` | 45,649,710,095,199,999,771 | ~45.65 |
| 8 | `0x9Fd6843163f3F501AcfC98188e49Ffb62A99645B` | 22,824,855,047,599,999,772 | ~22.82 |
| 9 | `0xAB5f9071D325b9B5844D52cD4e55ea6bbaCeB021` | 11,412,427,523,799,999,771 | ~11.41 |
| 10 | `0x3103f527ec280F37483c364A696D8cF4978a702B` | 9,814,687,670,467,999,772 | ~9.81 |
| 11 | `0x736DdE3E0F5c588dDC53ad7f0F65667C0Cca2801` | 2,443,693,693,693,693,692 | ~2.44 |
| 12 | `0xd3DAC9545613021b6a3530a0df21df7f1cf157f2` | 984,636,541,022,388,074 | ~0.98 |
| 13 | `0x005A3E49aF2Cf567D655c6cCb3e5982E1D55E72b` | 952,480,258,035,813,590 | ~0.95 |
| 14 | `0x88f6A56bB64A019F722E9d694e9F8C1876ccE687` | 952,480,258,035,813,590 | ~0.95 |
| 15 | `0x442BCb92f27fecc5d93d8d7307195F6617192321` | 946,561,641,006,085,450 | ~0.95 |
| 16 | `0x06005605Bc9a8F9c1eCd921775d5073031889880` | 615,238,254,127,143,016 | ~0.62 |
| 17 | `0x0D99E9a9cB81eF149ae2A1270a6C7a9593EdBa9b` | 606,002,828,225,050,447 | ~0.61 |
| 18 | `0x48e9E2F211371bD2462e44Af3d2d1aA610437f82` | 599,865,738,754,627,642 | ~0.60 |
| 19 | `0x17E32FdB2c47B2e46245e3ad25228cd3FAff230f` | 327,867,550,089,772,311 | ~0.33 |
| 20 | `0x8042b39539876bA7E04E3fC97EF37fd13613024A` | 177,061,982,617,538,173 | ~0.18 |
| | **TOTAL** | **968,517,168,940,900,914,046** | **~968.52** |

<img width="1430" height="381" alt="image" src="https://github.com/user-attachments/assets/3769d615-89a6-40c1-b675-2175d77798d9" />

Attack TX https://app.blocksec.com/phalcon/explorer/tx/eth/0xee55b9ed98a275fc2058dfa547e7af0af26cf6cd095c3af731b7c61453bca3dd

### Exec Flow

```
MarketplaceRefundContract (0x87d2...8c8B)
    |
    | x20 claimVirtueRefund() calls
    | (VIRTUE transferred to attack contract instead of victims)
    v
Attack Contract (0xE20151AF6F3BA0f7a2FD89B3A98Cb9C50768Ce16)
    |
    | transfer() of entire balance
    v
Attacker Wallet (0x622B4c078f1175c9aee10E9e79572F19cfEdfeAf)
```

<img width="1074" height="225" alt="image" src="https://github.com/user-attachments/assets/6a290ede-a9e0-4ac1-821c-456ba75491e6" />

---

## Impact

- **20 addresses** had their VIRTUE refunds stolen.
- Their claims are marked as `alreadyClaimedVirtue[_to] = true`, which **permanently prevents them from reclaiming their refund** through the current contract.
- Victims have no on-chain recourse without manual intervention by the contract owner (mapping reset or deployment of a new contract).

- **~968.52 VIRTUE** tokens stolen in a single transaction.
- Legitimate beneficiaries have no remaining on-chain remedy.

///////

Two factors combined to make this exploit possible:

1. **Development error (the vulnerability)**: use of `msg.sender` instead of `_to` as the token transfer recipient in the `claimVirtueRefund` function. The correct pattern was already implemented in `claimEthRefund` (line 104) which uses `_to` as the recipient. The `claimVirtueRefund` function was presumably not reviewed with the same attention, or fell victim to a poorly adapted copy-paste.

2. **Reconstructible Merkle tree (the enabler)**: the small number of total leaves (~446 addresses) and the fact that 426 had already claimed on-chain - exposing their full leaf data and proof sibling hashes in public calldata - allowed the attacker to reconstruct >85% of the tree. The remaining 20 unknown leaves were brute-forced by correlating marketplace source-of-funds amounts with candidate `(address, refundAmount)` pairs until each leaf matched a known gap in the tree.
