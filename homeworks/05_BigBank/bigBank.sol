// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./bank.sol";
import "./ownable.sol";

contract BigBank is Bank, Ownable{
    modifier checkAmount() {
        require(msg.value > 1000 wei, "Must to more than 0.001ETH");
        _;
    }

    receive() external payable override checkAmount {
        // 调用父合约的接收函数
    }

    // 提取资金的函数，只有 Ownable 合约的所有者可以调用
    function withdraw(uint256 amount) external view override onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance"); // 确保合约拥有足够的资金
    }
}
