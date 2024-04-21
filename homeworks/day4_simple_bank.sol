// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Bank {
    address public owner; // 合约的拥有者，即管理员地址
    mapping(address => uint256) public balances;
    address[3] public top3Users; // 存款金额前 3 名的用户地址

    // 构造函数，在部署合约时设置管理员地址
    constructor() {
        owner = msg.sender;
    }

    // 用户向合约存款的函数
    // function deposit() external payable {
    //     require(msg.value > 0, "Deposit amount must be greater than 0");
        
    //     balances[msg.sender] += msg.value;

    //     // 如果地址之前没有存款过，则将其加入 depositAddresses 数组
    //     if (balances[msg.sender] == msg.value) {
    //         depositAddresses.push(msg.sender);
    //         updateTop3Users(msg.sender);
    //     }
    // }
    // 题目理解错误，使用receive更合适，因为本身就有监听功能，而函数deposit()需要用户使用该函数才能执行

    // 接收以太币存款的函数
    receive() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        
        // 记录用户存款
        balances[msg.sender] += msg.value;
        
        // 更新在存款排行前三
        if (balances[msg.sender] >= balances[top3Users[0]]) {
            top3Users[2] = top3Users[1];
            top3Users[1] = top3Users[0];
            top3Users[0] = msg.sender;
        } else if (balances[msg.sender] >= balances[top3Users[1]]) {
            top3Users[2] = top3Users[1];
            top3Users[1] = msg.sender;
        } else if (balances[msg.sender] >= balances[top3Users[2]]) {
            top3Users[2] = msg.sender;
        }
    }

    // 显示存款金额前 3 名用户及其余额
    function displayTop3Users() external view returns (address[3] memory, uint256[3] memory) {
        return (top3Users, [balances[top3Users[0]], balances[top3Users[1]], balances[top3Users[2]]]);
    }

    // 提取资金的函数，仅管理员可调用
    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(amount <= address(this).balance, "Insufficient balance");

        payable(owner).transfer(amount);
    }

    // fallback 函数
    fallback() external payable {
        // 在这里可以对接收到的以太币进行处理
        // 可以读取 msg.sender 和 msg.value，进行相应的逻辑操作
    }
}
