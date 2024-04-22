// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./bigBank.sol";

// Ownable 合约管理合约的所有者
contract Ownable is BigBank{
    address public eoaOwner; // 合约所有者的地址

    // 构造函数，在部署合约时设置合约所有者
    constructor() {
        owner = msg.sender; // 部署合约的地址即为合约的所有者
    }
}