// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 本demo涉及：创建合约、存取行为
contract PiggyBank {
    // 【思维拆解 1：状态变量】
    // 这里的数据是永久存在链上的。
    // 我们需要记住谁是这个存钱罐的主人。
    address public owner; 

    // 【思维拆解 2：构造函数】
    // 合约出生（部署）的那一刻执行一次。
    // 就像你去买保险箱，买回来的那一刻，钥匙（权限）就交给你了。
    constructor() {
        // msg.sender 是一个全局变量，代表“当前在这个函数的人”
        // 部署时，msg.sender 就是你（部署者）。
        owner = msg.sender; 
    }

    // 【思维拆解 3：存钱逻辑】
    // 加上 'payable' 关键字，这个函数就能接收 ETH 了。
    // 没有这个关键字，给它打钱会报错（这是 Solidity 的安全机制）。
    function deposit() public payable {
        // 逻辑很简单：不需要写什么，钱已经自动进合约账户了。
        // 但为了方便看，我们一般会留空或者发个事件（以后讲）。
    }

    // 【思维拆解 4：取钱逻辑 - 核心！】
    // 本函数功能为提取全部金额
    // 这是最关键的一步：权限控制。
    function withdraw() public {
        // 第一步：安检。
        // require(条件, "报错信息");
        // 如果调用这个函数的人(msg.sender) 不是 owner，直接回滚，不仅不给钱，还扣他 Gas 费。
        require(msg.sender == owner, "You are not the owner!");

        // 第二步：提款。
        // address(this).balance 代表当前这个合约里有多少钱。
        uint256 balance = address(this).balance;
        
        // 第三步：转账。
        // 把钱转给 owner (payable(msg.sender))。
        payable(msg.sender).transfer(balance);
    }
    
    // 辅助功能：查看合约里有多少钱
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }


    // 上一个withdraw函数是一次性全取完
    // 本函数：指定金额取款
    // inputAmount 是一个参数，用户调用时需要填入这个数字
    function withdrawAmount(uint256 inputAmount) public {
        
        // 1. 依然要检查是不是主人
        require(msg.sender == owner, "Not owner");

        // 2. 新增检查：合约里有这么多钱给你取吗？
        // address(this).balance 是合约当前的余额
        require(address(this).balance >= inputAmount, "Insufficient balance in contract");

        // 3. 转账
        // 这里转账的金额变成了 inputAmount，而不是全部余额
        payable(msg.sender).transfer(inputAmount);
    }

}