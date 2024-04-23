// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

contract TokenBank {
    // 代币合约地址 => 用户地址 => 存款数量
    mapping(address => mapping(address => uint256)) public userTokenBalances;

    /** 将代币存入 TokenBank */
    function deposit(address token, uint256 amount) public {
        BaseERC20 erc20 = BaseERC20(token); // 实例化代币合约
        erc20.transferFrom(msg.sender, address(this), amount); // 将代币从用户地址转移到 TokenBank
        userTokenBalances[token][msg.sender] += amount; // 更新用户的存款数量
    }

    /** 从 TokenBank 取出代币 */
    function withdraw(address token, uint256 amount) public {
        uint256 balance = userTokenBalances[token][msg.sender]; // 获取用户的存款数量
        require(balance >= amount, "Insufficient balance"); // 确保用户的存款足够
        BaseERC20 erc20 = BaseERC20(token); // 实例化代币合约
        erc20.transfer(msg.sender, amount); // 将代币从 TokenBank 转移到用户地址
        userTokenBalances[token][msg.sender] -= amount; // 更新用户的存款数量
    }
}
