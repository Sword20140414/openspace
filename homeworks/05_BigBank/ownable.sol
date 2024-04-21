// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

// Ownable 合约管理合约的所有者
contract Ownable {
    address public eoaOwner; // 合约所有者的地址

    // 构造函数，在部署合约时设置合约所有者
    constructor() {
        eoaOwner = msg.sender; // 部署合约的地址即为合约的所有者
    }

    // 修饰器，确保只有合约所有者可以调用标记了该修饰器的函数
    modifier onlyOwner() virtual {
        require(msg.sender == eoaOwner, "Only owner can call this function");
        _;
    }

    // 转移合约所有者权限给新地址
    function transferOwnership(address newOwner) external virtual onlyOwner {
        require(newOwner != address(0), "Invalid address"); // 确保新地址有效
        eoaOwner = newOwner; // 转移合约所有者权限
    }
}