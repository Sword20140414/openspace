// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

// 安全数学
contract SafeMath {
    function testUnderflow() public pure returns (int) {
        int x = 0;
        x--;
        return x;
    }
}