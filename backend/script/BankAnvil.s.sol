// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Bank.sol";

// 请先启动anvil获得本地链，再运行
contract BankScript is Script {
    function run() external {
        // 1. 设置发送者私钥
        // 注意：这是 Anvil 默认的第一个测试账户私钥，仅限本地测试使用！
        // 绝对不要把真实资产的私钥写在这里！
        uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        
        // 2. 开始广播交易（startBroadcast 之后的操作都会上链）
        vm.startBroadcast(deployerPrivateKey);

        // 3. 部署合约
        new Bank();

        // 4. 结束广播
        vm.stopBroadcast();
    }
}