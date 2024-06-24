// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {Script} from "forge-std/Script.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    MyNFT myNFT;

    function run() external returns (MyNFT) {
        vm.startBroadcast();
        myNFT = new MyNFT();
        vm.stopBroadcast();
        return myNFT;
    }
}
