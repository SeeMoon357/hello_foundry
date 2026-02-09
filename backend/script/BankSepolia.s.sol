// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Bank.sol";

// 本文件的运行，意味着实现真正的上链了（以太坊的sepolia测试链）
contract BankScript is Script {
    function run() external {
        // 【修改点 1】删掉或是注释掉那行 uint256 deployerPrivateKey = ...
        
        // 【修改点 2】括号里留空！
        // 意思是：不要指定特定私钥，而是使用我们在命令行里传进来的那个账号。（开发者账号的私钥被放在了ubuntu的foundry中保存，现在调出来用）
        vm.startBroadcast(); 

        new Bank();

        vm.stopBroadcast();
    }
}