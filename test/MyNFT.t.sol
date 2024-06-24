// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../src/MyNFT.sol";
import {DeployMyNFT} from "../script/DeployMyNFT.s.sol";

contract MyNFTTest is Test {
    MyNFT myNFT;
    DeployMyNFT deplayMyNFT;

    function setUp() public {
        deplayMyNFT = new DeployMyNFT();
        myNFT = deplayMyNFT.run();
    }

    // 测试铸造NFT
    function test_mintSuccess() public {
        uint256 tokenId = myNFT.mint("firstNFT", "my first NFT");
        (string memory name, string memory description, address owner) = myNFT
            .getNFT(tokenId);
        assertEq(name, "firstNFT");
        assertEq(description, "my first NFT");
        assertEq(owner, address(this));
    }

    // 测试当前账户拥有的NFT数量
    function test_getOwnerNFTCounts() public view {
        uint256[] memory nfts = myNFT.getTokensByOwner(address(this));
        /**
         * 此处，assertEq(nfts.length, 1); 会执行失败，提示 0!=1
         * 因为：每个测试函数在执行时，合约的状态都是独立的，也就是说，每个测试函数都时在一个新的区块链中运行的。
         * 之前的测试函数中状态的变化，不会影响另一个测试函数中的状态。
         * 所以 assertEq(nfts.length, 1); 失败
         */
        // assertEq(nfts.length, 1);
        assertEq(nfts.length, 0);
    }

    /**
     * 此处我想重用铸造NFT的代码，有三种方式
     * 1. 将铸造NFT的代码放在 setUp() 函数中
     * 2. 将铸造代码封装成函数，在每个测试用例中调用。
     * 3. 将公共代码转为抽象合约，使测试类继承抽象合约，从而实现公共代码的复用。
     */

    function test_transferSuccess() public {
        // 1.铸造NFT
        uint256 tokenId = myNFT.mint("TT", "my first NFT");
        // 2.获取NFT信息
        // (string memory name, string memory description, address owner) = myNFT
        //     .getNFT(tokenId);
        // 3.转移NFT
        myNFT.transfer(
            address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            tokenId
        );
        // 4.验证
        (, , address newOwner) = myNFT.getNFT(tokenId);
        assertEq(newOwner, address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266));
    }

    /**
     * 测试销毁NFT
     */
    function test_burnSuccess() public {
        uint256 tokenId = myNFT.mint("TT", "my first NFT");
        myNFT.burn(tokenId);
        assertEq(myNFT.getTokensByOwner(address(this)).length, 0);
    }
}
