# 题目

编写一个 TokenBank 合约，可以将自己的 Token 存入到 TokenBank， 和从 TokenBank 取出。

TokenBank 有两个方法：

1. deposit() : 需要记录每个地址的存入数量；
2. withdraw（）: 用户可以提取自己的之前存入的 token。

## 截图如下：

1. 代币合约地址: 0x7b96aF9Bd211cBf6BA5b0dd53aa61Dc5806b6AcE
   代币银行合约地址: 0x3328358128832A260C76A4141e19E2A943CD4B6D

2. 使用代币EOA地址(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)向代币银行合约授权（其实我不能完全理解授权金额这个步骤，比如授权金额是记录在哪里，每次使用了金额是在哪里做的这些运算）
   
3. 分别给代币银行合约地址（0x3328358128832A260C76A4141e19E2A943CD4B6D）和用户地址（0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2）转 100000 

4. 
   