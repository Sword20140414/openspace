// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

contract Bank {
    address public owner; // 合约的拥有者，即管理员地址
    mapping(address => uint256) public balances;
    address[] public depositAddresses;
    address[3] public top3Users; // 存款金额前 3 名的用户地址
    uint256[3] public top3Balances; // 存款金额前 3 名的用户余额

    // 构造函数，在部署合约时设置管理员地址
    constructor() {
        owner = msg.sender;
    }

    // 用户向合约存款的函数
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        balances[msg.sender] += msg.value;

        // 如果地址之前没有存款过，则将其加入 depositAddresses 数组
        if (balances[msg.sender] == msg.value) {
            depositAddresses.push(msg.sender);
            updateTop3Users(msg.sender);
        }
    }

    // 更新存款金额前 3 名的用户数组
    function updateTop3Users(address newUser) private {
        // 将新用户加入 top3Users 数组
        for (uint256 i = 0; i < top3Users.length; i++) {
            // 如果当前位置为空或者新用户的余额大于当前位置用户的余额，则插入新用户
            if (top3Users[i] == address(0) || balances[newUser] > balances[top3Users[i]]) {
                // 将原有用户向后移动
                for (uint256 j = top3Users.length - 1; j > i; j--) {
                    top3Users[j] = top3Users[j - 1];
                    top3Balances[j] = top3Balances[j - 1];
                }
                // 插入新用户
                top3Users[i] = newUser;
                top3Balances[i] = balances[newUser];
                break;
            }
        }
    }

    // 显示存款金额前 3 名用户及其余额
    function displayTop3Users() external view returns (address[3] memory, uint256[3] memory) {
        return (top3Users, top3Balances);
    }

    // 提取资金的函数，仅管理员可调用
    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(amount <= address(this).balance, "Insufficient balance");

        payable(owner).transfer(amount);
    }
}
