// 本dmemo: 实现权限控制，有的事只能让合约创建者做，不能让用户做
// 需要先安装OpenZeppelin 的库文件
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 1. 【新增】导入权限控制标准库
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// 2. 【新增】继承 Ownable
// 这里的 "is Ownable" 意思是：SafeBank 继承了 Ownable 的所有能力
contract SafeBank is Ownable {
    
    // --- 原有逻辑保持不变 ---
    mapping(address => uint256) public balances;
    event Deposit(address indexed user, uint256 amount);

    // 3. 【修改】构造函数
    // OpenZeppelin 的 Ownable 需要你指定谁是初始老大
    // 这里我们将部署者 (msg.sender) 设为老大
    constructor() Ownable(msg.sender) {}

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Not enough money");
        balances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    // --- 【新增】V2 特有功能 ---

    // 4. 只有管理员能调用的“提现手续费”功能
    // (这里仅演示功能，假设合约里有多余的钱作为手续费)
    function withdrawAllMoney() public onlyOwner {
        // onlyOwner 是一个修饰符。
        // 它会先检查：调用人是 Owner 吗？
        // 如果是 -> 继续执行。
        // 如果不是 -> 直接报错回滚。
        
        uint256 totalBalance = address(this).balance;
        payable(owner()).transfer(totalBalance);
    }
}