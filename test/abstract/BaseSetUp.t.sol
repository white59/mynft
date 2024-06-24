// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Test} from "forge-std/Test.sol";
import {MyNFT} from "../../src/MyNFT.sol";
import {DeployMyNFT} from "../../script/DeployMyNFT.s.sol";

/**
 * @title 抽象合约，定义初始化方法和状态变量
 * @author white59
 * @notice
 */
contract BaseSetUp is Test {
    MyNFT myNFT;
    DeployMyNFT deployMyNFT;

    function setUp() public virtual {
        deployMyNFT = new DeployMyNFT();
        myNFT = deployMyNFT.run();
    }

    function mintNFT(
        string memory _name,
        string memory _description
    ) internal returns (uint256) {
        return myNFT.mint(_name, _description);
    }
}
