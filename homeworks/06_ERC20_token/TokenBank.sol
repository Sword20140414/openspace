// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

contract TokenBank {
    BaseERC20 public token; // 存储的代币合约地址
    mapping(address => uint256) public balances; // 记录每个地址存入的代币数量

    event Deposit(address indexed from, uint256 value); // 存款事件
    event Withdrawal(address indexed to, uint256 value); // 取款事件

    constructor(address _tokenAddress) {
        token = BaseERC20(_tokenAddress); // 初始化代币合约地址
    }

    // 存款函数
    function deposit(uint256 _amount) external {
        require(_amount > 0, "Deposit amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed"); // 从发送者转入代币到 TokenBank
        balances[msg.sender] += _amount; // 更新存款地址的余额
        emit Deposit(msg.sender, _amount); // 触发存款事件
    }

    // 取款函数
    function withdraw(uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(balances[msg.sender] >= _amount, "Insufficient balance"); // 确保账户余额足够
        require(token.transfer(msg.sender, _amount), "Transfer failed"); // 从 TokenBank 转出代币到发送者
        balances[msg.sender] -= _amount; // 更新存款地址的余额
        emit Withdrawal(msg.sender, _amount); // 触发取款事件
    }
}
