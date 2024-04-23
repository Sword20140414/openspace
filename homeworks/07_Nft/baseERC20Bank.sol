// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

contract TokenBank {
    // 代币合约地址 => 用户地址 => 存款数量
    mapping(address => uint256) public userTokenBalances;
    BaseERC20 erc20;

    event TokenReceived(address indexed recepient, uint256 amount); // 接受转账

    constructor(address _addr) {
        erc20 = BaseERC20(_addr); // Initialize the state variable erc20
    }

    /** 将代币存入 TokenBank */
    function deposit(uint256 amount) public {
        erc20.transferFromWithCallback(msg.sender, address(this), amount);
    }

    /** 从 TokenBank 取出代币 */
    function withdraw(uint256 amount) public {
        uint256 balance = userTokenBalances[msg.sender]; // 获取用户的存款数量
        require(balance >= amount, "Insufficient balance"); // 确保用户的存款足够
        erc20.transfer(msg.sender, amount); // 将代币从 TokenBank 转移到用户地址
        userTokenBalances[msg.sender] -= amount; // 更新用户的存款数量
    }

    /** token的received */
    function tokensReceived(address from, uint256 amount) external returns (bool) {
        userTokenBalances[msg.sender] += amount;
        emit TokenReceived(from, userTokenBalances[msg.sender]);
        return true;
    }  
}