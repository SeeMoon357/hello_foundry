// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 本demo涉及：分账户记账（映射mapping）、小票证明(事件events)
contract Bank {
    // 【核心概念：Mapping】
    // 语法：mapping(KeyType => ValueType) 变量名;
    // 想象它是一个巨大的账本：
    // 左边一列是“账户地址(address)”，右边一列是“余额(uint256)”。
    // 比如：
    // 0x123... -> 100 Wei
    // 0x456... -> 200 Wei
    mapping(address => uint256) public balances;

    // 定义事件
    event Deposit(address indexed user, uint256 amount);

    // 存钱函数
    function deposit() public payable {
        // 1. 钱已经进合约了 (address(this).balance 增加了)
        // 2. 但我们还需要在“小账本”上记一笔，记在存钱人(msg.sender)名下。
        
        // 写法：查表，把这行原来的数，加上这次存的数(msg.value)
        balances[msg.sender] += msg.value;

        // 触发事件
        emit Deposit(msg.sender, msg.value);
    }

    // 取钱函数
    function withdraw(uint256 amount) public {
        // 步骤 1: 检查这人账本里的余额够不够？
        // 提示：去 balances 里查 msg.sender 的余额，看它是不是 >= amount
        require(balances[msg.sender] >= amount, "Not enough money");

        // 步骤 2: 扣除账本余额（重要！先扣钱，再转账，防止安全漏洞）
        // 不要写成了扣除msg.value，是存钱的变量
        balances[msg.sender] -= amount;


        // 步骤 3: 真正把 ETH 转给他
        payable(msg.sender).transfer(amount);
    }
    
    // 辅助函数：查我看我自己的余额
    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}