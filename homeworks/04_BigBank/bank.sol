// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

interface IBank {
    function withdraw() external;
}

contract Bank {
    address public owner; // 合约的拥有者，即管理员地址
    mapping(address => uint256) public balances;
    address[3] public top3Users; // 存款金额前 3 名的用户地址

    // 构造函数，在部署合约时设置管理员地址
    constructor() {
        owner = msg.sender;
    }

    // 检查是否是管理员的装饰器
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can withdraw funds");
        _;
    }

    // 记录转账，更新存款前三的用户
    function deposit() public payable virtual {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        // 记录用户存款
        balances[msg.sender] += msg.value;
        upTop3();
    }


    receive() external payable virtual{
        deposit();
    }

    // 更新前 3 名的用户地址
    function upTop3() public virtual {
        // 更新在存款排行前三
        // 目前有个问题，如果是前三名的用户继续存款，该用户有可能同时占前两名及以上
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
    function displayTop3Users() external view virtual returns (address[3] memory, uint256[3] memory) {
        return (top3Users, [balances[top3Users[0]], balances[top3Users[1]], balances[top3Users[2]]]);
    }

    // 提取资金的函数，仅管理员可调用
    function withdraw(uint256 amount) external virtual onlyOwner {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(owner).transfer(amount);
    }
}
