// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

// 显示数据类型
contract ValueType {
    bool public b = true;
    uint public u = 234;
    int public i = -234;
    int public minInt = type(int).min;
    int public maxInt = type(int).max;
    address public addr = 0x01a1f994AD69c356eBbEe8879456E55488888888;
    bytes32 public b32 = 0xa79beced8de4f55e19edf2a8333db49af14a5006de82fd41fccba2dc28ab0dcc;
}