// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 回调接口
interface MyCallBack {
    // 回调函数
    function tokenReceived(address _recipient, uint256 _tokens) external returns (bool);
}