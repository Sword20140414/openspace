// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.7.4;

// 函数的基本运用
contract FunctionIntro {
    function add(uint x, uint y) external pure returns (uint) {
        return x + y;
    }

    function sub(uint x, uint y) external pure returns (uint) {
        if (x > y){
            return x - y;
        } else if (y > x) {
            return y - x;
        } else {
            return 0;
        }
    }
}