// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";
import {BaseSetUp} from "./abstract/BaseSetUp.t.sol";

contract MyNFTWithAbstract is BaseSetUp {
    function setUp() public override {
        super.setUp();
    }

    /**
     * 测试铸造NFT
     */
    function test_mintSuccess() public {
        uint256 tokenId = mintNFT("firstNFT", "Test Abstract Token");
        (string memory name, string memory description, address owner) = myNFT
            .getNFT(tokenId);
        assertEq(name, "firstNFT");
        assertEq(description, "my first NFT");
        assertEq(owner, address(this));
    }

    // 测试当前账户拥有的NFT数量
    function test_getOwnerNFTCounts() public {
        // 先铸造一个NFT
        mintNFT("testNFT", "my test NFT");

        // 获取当前账户拥有的NFT数量
        uint256[] memory nfts = myNFT.getTokensByOwner(address(this));
        assertEq(nfts.length, 1);
    }
}
