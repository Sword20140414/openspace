// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
    }
}

contract Bank {
    address public owner; // 合约的拥有者，即管理员地址

    // 构造函数，在部署合约时设置管理员地址
    constructor() {
        owner = msg.sender;
    }

    // 提取资金的函数，仅管理员可调用
    function withdraw(uint256 amount) external {
        require(msg.sender == owner, "Only owner can withdraw funds");
        require(amount <= address(this).balance, "Insufficient balance");

        payable(owner).transfer(amount);
    }
}

contract BigBank is Bank {
    Ownable public ownable;

    constructor(address _ownable) {
        ownable = Ownable(_ownable);
    }

    function withdraw(uint256 amount) external {
        require(ownable.owner() == msg.sender, "Only Ownable contract can call this function");
        require(amount <= address(this).balance, "Insufficient balance");

        payable(msg.sender).transfer(amount);
    }

    function transferOwnershipToOwnable(address newOwner) external {
        ownable.transferOwnership(newOwner);
    }
}
