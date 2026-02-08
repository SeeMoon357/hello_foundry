// 对应MyToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/MyToken.sol"; // 注意这里的文件名要对应

contract DeployTokenScript is Script {
    function run() external {
        vm.startBroadcast();

        // 部署代币合约
        new MoonToken();

        vm.stopBroadcast();
    }
}