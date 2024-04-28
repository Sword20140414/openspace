// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./bank.sol";

/*
编写一个 BigBank 合约， 它继承自该挑战 的 Bank 合约，并实现功能：

要求存款金额 >0.001 ether（用modifier权限控制）
BigBank 合约支持转移管理员
同时编写一个 Ownable 合约，把 BigBank 的管理员转移给Ownable 合约， 实现只有Ownable 可以调用 BigBank 的 withdraw().
编写 withdraw() 方法，仅管理员可以通过该方法提取资金。
用数组记录存款金额的前 3 名用户
*/


contract BigBank is Bank{
    // 要求存款金额 >0.001 ether（用modifier权限控制）
    modifier checkAmount() {
        require(msg.value > 0.001 ether, "Must to more than 0.001ETH");
        _;
    }

    receive() external payable override checkAmount {
        // 调用父合约的接收函数
        require(msg.value > 0, "Deposit amount must be greater than 0");
    }

    // BigBank 合约支持转移管理员
    function setOwner (address newOwner) public onlyOwner {
        owner = newOwner;
    }

    function deposit() public payable override checkAmount() {
        super.deposit();
    }    
}


contract Ownable {
    address owner;

    constructor() {
        // 同时编写一个 Ownable 合约，把 BigBank 的管理员转移给Ownable 合约
        owner = msg.sender;
    }

    function withdraw(address bankAddress) public {
        // 编写 withdraw() 方法，仅管理员可以通过该方法提取资金。
        require(msg.sender == owner, "Only owner can withdraw funds");
        IBank(bankAddress).withdraw();
    }

    receive() external payable {}
}
