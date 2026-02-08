// 本demo完成：发币练习
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 导入 ERC20 标准库
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// 2. 导入权限控制（可选，但这很酷，让你可以后续增发）
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MoonToken is ERC20, Ownable {
    // 3. 构造函数
    // 这里的 "Moon Token" 是全名，"MOON" 是代币符号（Ticker）
    constructor() ERC20("Moon Token", "MOON") Ownable(msg.sender) {
        // 4. 给自己铸造（Mint）初始代币
        // 1000000 * 10 ** decimals() 意思是：100万个币
        // 因为 Solidity 不支持小数，所以要乘以 10 的 18 次方
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // 5. 增发功能（只有老板能调）
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}