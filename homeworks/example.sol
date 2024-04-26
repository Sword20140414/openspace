// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Bank {
    address public owner; // 合约的拥有者，即管理员地址
    mapping(address => uint256) public balances; //记录所有用户余额
    address[3] public top3Users; // 存款金额前 3 名的用户地址

    // 构造函数，在部署合约时设置管理员地址
    constructor() {
        owner = msg.sender;
    }

    // 检查是否是管理员的修饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw funds");
        _;
    }

    // 接收以太币存款的函数
    receive() external payable virtual {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        // 记录用户存款
        balances[msg.sender] += msg.value;
        updateTop3Users(msg.sender);
    }

    // 更新前 3 名的用户地址
    function updateTop3Users(address user) internal {
        // 寻找插入位置并将用户插入
        uint256 userBalance = balances[user];
        uint256 lastIndex = 0;
        for (uint256 i = 0; i < top3Users.length; i++) {
            if (userBalance > balances[top3Users[i]]) {
                // 移除原有用户
                for (uint256 j = top3Users.length - 1; j > i; j--) {
                    top3Users[j] = top3Users[j - 1];
                }
                lastIndex = i;
                break;
            }
            lastIndex = i;
        }
        // 插入新用户
        if (lastIndex < top3Users.length) {
            top3Users[lastIndex] = user;
        }
    }

    // 显示存款金额前 3 名用户及其余额
    function displayTop3Users() external view virtual returns (address[3] memory, uint256[3] memory) {
        uint256[3] memory balancesTop3;
        for (uint256 i = 0; i < top3Users.length; i++) {
            balancesTop3[i] = balances[top3Users[i]];
        }
        return (top3Users, balancesTop3);
    }

    // 提取资金的函数，仅管理员可调用
    function withdraw(uint256 amount) external virtual onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
