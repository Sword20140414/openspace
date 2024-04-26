// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./bank.sol";

// 定义取款接口
interface MyWithDraw {
    function withdraw(uint amount) external;
}

contract BigBank is Bank{
    // 检查金额是否大于0.001ETH
    modifier checkAmount() {
        require(msg.value > 1000 wei, "Must to more than 0.001ETH");
        _;
    }

    receive() external payable override checkAmount {
        // 调用父合约的接收函数
        require(msg.value > 0, "Deposit amount must be greater than 0");
    }

    // 转移管理员
    function setOwner (address newOwner) public onlyOwner {
        owner = newOwner;
    }    

    // 提取资金的函数，只有 Ownable 合约的所有者可以调用
    function withdraw(uint256 amount) external view override onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance"); // 确保合约拥有足够的资金
    }
}
