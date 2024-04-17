// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.4;

contract Counter {

    uint256 counter = 1024;


    function get() public view returns(uint256) {
        return counter;
    }


    function add(uint256 num) public {
        counter = counter + num;
    }
}