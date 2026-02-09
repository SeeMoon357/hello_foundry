// SPCD删去了，若运行，加上
// pragma solidity ^0.8.0;

// import "forge-std/Test.sol"; // 导入 Foundry 的测试工具箱
// import "../src/Bank.sol";    // 导入你要测试的合约

// contract BankTest is Test {
//     Bank public bank;
//     address user1 = address(0x123); // 模拟用户1
//     address hacker = address(0x456); // 模拟黑客

//     // 每次测试前都会运行一次，相当于“初始化战场”
//     function setUp() public {
//         bank = new Bank();
//         // 给用户 10 个 ETH 练手
//         vm.deal(user1, 10 ether);
//         vm.deal(hacker, 10 ether);
//     }

//     // 测试 1：正常的存款逻辑
//     function testDeposit() public {
//         vm.startPrank(user1); // 假装我是 user1
//         bank.deposit{value: 1 ether}();
//         vm.stopPrank();

//         assertEq(bank.balances(user1), 1 ether); // 断言：user1 的账本应该是 1 ETH
//     }

//     // 测试 2：黑客测试（越权取款）
//     function testHackerCannotWithdrawUser1Money() public {
//         // 第一步：用户1 存了 5 个 ETH
//         vm.prank(user1);
//         bank.deposit{value: 5 ether}();

//         // 第二步：黑客试图从 bank 取走 5 个 ETH
//         vm.prank(hacker); 
        
//         // 我们【预期】下一行代码会报错（revert）
//         // 报错信息必须包含我们在 Bank.sol 里写的 "Not enough money"
//         vm.expectRevert("Not enough money");
//         bank.withdraw(5 ether);
//     }
// }

// 注释看上面被注释的就好。代码改了几行，功能性基本没变
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    Bank public bank;
    address user1 = makeAddr("user1"); // 推荐用这个方法生成清晰的地址
    address hacker = makeAddr("hacker");

    function setUp() public {
        bank = new Bank();
        vm.deal(user1, 10 ether);
        vm.deal(hacker, 10 ether);
    }

    function test_Deposit() public {
        vm.prank(user1);
        bank.deposit{value: 1 ether}();
        assertEq(bank.balances(user1), 1 ether);
    }

    function test_RevertWhen_HackerWithdraws() public {
        vm.prank(user1);
        bank.deposit{value: 5 ether}();

        // 预期下一次调用会失败
        vm.expectRevert("Not enough money");
        vm.prank(hacker);
        bank.withdraw(5 ether);
    }
}