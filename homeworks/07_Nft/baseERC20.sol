// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyCallBack.sol";

contract BaseERC20 {
    string public name; // 代币名称
    string public symbol; // 代币符号
    uint8 public decimals; // 小数位数
    uint256 public totalSupply; // 总供应量
    mapping (address => uint256) balances; // 余额映射
    mapping (address => mapping (address => uint256)) allowances; // 授权映射
    event Transfer(address indexed from, address indexed to, uint256 value); // 转账事件
    event Approval(address indexed owner, address indexed spender, uint256 value); // 授权事件
    event TransferCallback(address indexed from, address indexed to, uint256 value); // 回调

    constructor() {
        name = "BaseERC20"; // 设置代币名称
        symbol = "BERC20"; // 设置代币符号
        decimals = 18; // 设置小数位数
        totalSupply = 100_000_000 * (10 ** uint256(decimals)); // 设置总供应量，18位小数
        balances[msg.sender] = totalSupply; // 将总供应量分配给合约创建者
    }

    // 查看指定地址的余额
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    // 从发送者转账给指定地址
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_value <= balances[msg.sender], "ERC20: transfer amount exceeds balance");
        balances[msg.sender] -= _value; // 减少发送者的余额
        balances[_to] += _value; // 增加接收者的余额
        emit Transfer(msg.sender, _to, _value); // 发送转账事件
        return true;
    }

    // 从指定地址转账到另一个地址
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balances[_from], "ERC20: transfer amount exceeds balance");
        require(_value <= allowances[_from][msg.sender], "ERC20: transfer amount exceeds allowance");
        balances[_from] -= _value; // 减少发送者的余额
        balances[_to] += _value; // 增加接收者的余额
        allowances[_from][msg.sender] -= _value; // 减少发送者的授权额度
        emit Transfer(_from, _to, _value); // 发送转账事件
        return true;
    }

    // 授权给指定地址一定数量的代币
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value; // 设置指定地址的授权额度
        emit Approval(msg.sender, _spender, _value); // 发送授权事件
        return true;
    }

    // 获取指定地址对另一个地址的授权额度
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender]; // 返回授权额度
    }

    // 增加回调功能的 transfer 函数
    function transferFromWithCallback(address _from, address _to, uint256 _value) public returns (bool success) {
        require(transferFrom(_from, _to, _value), "Fail to transfer with callback");
        if (isContract(_to)) {
            require(MyCallBack(_to).tokenReceived(_from, _value), "Fail to invoke tokensReceived function");
            emit TransferCallback(_from, _to, _value);
        }
        return true;
    }

    // 检查地址是否是合约
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }


}
