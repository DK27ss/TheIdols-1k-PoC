// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IMarketplaceRefundContract {
    function claimVirtueRefund(
        address _to,
        uint256 _refundAmount,
        bytes32[] calldata _merkleProof
    ) external;
}

interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

contract IdolVRA {
    IMarketplaceRefundContract constant REFUND =
        IMarketplaceRefundContract(0x87d2EdBA911c7E2E13580af897bA77E47e8B8c8B);
    IERC20 constant VIRTUE =
        IERC20(0x9416bA76e88D873050A06e5956A3EBF10386b863);

    struct Claim {
        address vcmi;
        uint256 amount;
        bytes32[8] proof;
    }

    function exec(Claim[] calldata claims) external {
        for (uint256 i; i < claims.length; i++) {
            bytes32[] memory proof = new bytes32[](8);
            for (uint256 j; j < 8; j++) proof[j] = claims[i].proof[j];
            REFUND.claimVirtueRefund(claims[i].vcmi, claims[i].amount, proof);
        }

        uint256 bal = VIRTUE.balanceOf(address(this));
        VIRTUE.transfer(msg.sender, bal);
    }
}
