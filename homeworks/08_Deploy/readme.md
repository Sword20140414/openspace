##部署合约

## 部署合约流程

1. 使用 froge create 来部署合约

2. 指定一个钱包
   - private key
   - keystore: 指定了加密私钥文件的路径, 执行时输入密码
   - account: 从默认的文件夹里面获取keystore, 执行时输入密码

3. 选择一个链
    -- chain

4. 选择一个RPC节点
    - https://chainlist.org
    - 自有节点
    - 付费节点: infura.io       clchem.io
    - 本地节点


## 使用 cast

    - `cast wallet -import -i admin1` 输入 private key, 再输入 password
    - `cast wallet address --account admin1` 检验密码是否正确
    - `cast send -i --rpc-url 127.0.0.1:8545 --value 2ether 0x5376cE606c9A1e14aB6C4a2388Fd4B3C73C73DC7`    本地转账
    - `cast call 0x94fd5b9f95c8f4b831a1a58609add230c6658639 "name()returns(string)"`    执行获取合约名称    
    - `cast send --account sword 0x94fd5b9f95c8f4b831a1a58609add230c6658639 "mint(address,uint256)" "0x5376cE606c9A1e14aB6C4a2388Fd4B3C73C73DC7" 20000` 本地节点mint
    - `cast balance --rpc-url https://eth-sepolia-public.unifra.io 0x5376cE606c9A1e14aB6C4a2388Fd4B3C73C73DC7`

## anvil

    搭建本地节点

## 部署合约
`forge create --account sword  MyToken`

详情可以参考 https://book.getfoundry.sh/
+++++