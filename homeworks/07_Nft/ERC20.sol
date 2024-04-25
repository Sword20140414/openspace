// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {

    mapping(address => uint256) public balances;

    mapping(address => mapping(address => uint256)) public allowance;

    string public name;     // 名称
    string public symbol;   // 符号

    uint8 public decimals = 18;      // 小数位数
    uint256 public totalSupply;     // 代币总量

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);


    // 在合约部署的时候实现合约名称和符号,以及代币总量
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
        totalSupply = 1000000 * 10 ** 18;

        balances[msg.sender] = totalSupply;      // 将代码转移给创建合约地址
    }

    modifier inspectionAmount(uint amount) {
        require(balances[msg.sender] >= amount, "ERC20: transfer amount exceeds balance");
        _;
    }

    modifier inspectionAllowances(address spender, uint amount) {
        require(allowance[msg.sender][spender] >= amount, "ERC20: transfer amount exceeds allowance");
        _;
    }

    // 代币转账
    function transfer(address recipient, uint amount) public inspectionAmount(amount) returns (bool) {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    // 查代币余额
    function balanceOf(address spender) public view returns (uint balance) {
        return balances[spender];
    }

    // 代币授权
    function approve(address spender, uint amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 代币授权转账
    function transferFrom(address sender, address recipient, uint amount) public inspectionAmount(amount) inspectionAllowances(sender, amount) returns (bool transferStatus) {
        allowance[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // 获取地址授权余额
    function allowanceValue() public view returns (uint) {
        return allowance[address(this)][msg.sender];
    }

    // 判断地址是否为合约地址
    function isContract(address address_) private view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(address_)
        }
        return size > 0;
    }

    // 如果是合约地址，使用合约地址中的tokenReceived方法
    // 抄的，不能完全理解这代码是怎么来的
    // 有几个问题，这个只检测合约转给接受方的，不考虑用户转给接受方的吗
    // 
    // function safeTransfer(address contractAddress, address recipient, uint amount) public inspectionAmount(amount) returns (bool transferStatus) {
    //     if (isContract(recipient)) {
    //         (bool success, bytes memory data) = contractAddress.call(
    //             abi.encodeWithSignature("tokensReceived(address,address,_value)", msg.sender, recipient, amount));
    //         bool result = abi.decode(data, (bool));

    //         if (result) {
    //             balances[recipient] += amount;
    //             balances[msg.sender] -= amount;
    //             emit Transfer(msg.sender, recipient, amount);
    //             return true;
    //         } else {
    //             return false;
    //         }
    //     } else {
    //         emit Transfer(msg.sender, recipient, amount);
    //         return transfer(recipient, amount);
    //     }
    // }
    function safeTransfer(
        address contractAddress,
        address _to,
        uint256 _value
    ) public inspectionAmount(_value) returns (bool transferStatus) {
        if (isContract(_to)) {
            (bool success, bytes memory data) = contractAddress.call(
                abi.encodeWithSignature(
                    "tokensReceived(address,address,uint256)",
                    msg.sender,
                    _to,
                    _value
                )
            );

            require(success, "External contract call failed");

            (bool result) = abi.decode(data, (bool));

            if (result) {
                balances[_to] += _value;
                balances[msg.sender] -= _value;
                emit Transfer(msg.sender, _to, _value);
                return true;
            } else {
                return false;
            }
        } else {
            emit Transfer(msg.sender, _to, _value);
            return transfer(_to, _value);
        }
    }
}
