import hashlib
import json
from time import time

def valid_proof(last_proof, proof, difficulty):
    """
    验证证明: 是否hash(last_proof, proof)以指定数量的0开头?
    
    参数:
        last_proof (int): 上一个证明
        proof (int): 当前证明
        difficulty (int): 挖矿难度，表示哈希值以多少个 0 开头
    
    返回:
        bool: 如果正确则返回 True，否则返回 False
    """
    guess = f'{last_proof}{proof}'.encode()
    guess_hash = hashlib.sha256(guess).hexdigest()
    return guess_hash[:difficulty] == "0" * difficulty

class Block:
    def __init__(self, index, timestamp, data, previous_hash):
        """
        构造函数，初始化区块的属性

        参数:
            index (int): 区块在链中的位置
            timestamp (float): 区块被创建的时间戳
            data (any): 区块包含的数据，可以是交易数据等
            previous_hash (str): 前一个区块的哈希值
        """
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.nonce = 0  # 随机数，用于 POW
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        """
        计算区块的哈希值

        返回:
            str: 区块的哈希值
        """
        # 将区块的属性转换成 JSON 格式并排序，然后进行哈希运算
        block_string = json.dumps({
            "index": self.index,
            "timestamp": self.timestamp,
            "data": self.data,
            "previous_hash": self.previous_hash,
            "nonce": self.nonce
        }, sort_keys=True).encode()
        return hashlib.sha256(block_string).hexdigest()

    def mine_block(self, difficulty):
        """
        挖矿，找到符合难度要求的哈希值

        参数:
            difficulty (int): 挖矿难度，表示哈希值以多少个 0 开头
        """
        while self.hash[:difficulty] != '0' * difficulty:
            self.nonce += 1
            self.hash = self.calculate_hash()

class Blockchain:
    def __init__(self):
        """
        构造函数，初始化区块链

        属性:
            chain (list): 存储区块的列表
            difficulty (int): 挖矿难度
        """
        self.chain = []
        self.difficulty = 4  # 挖矿难度为 4 个 0 开头
        self.create_genesis_block()

    def create_genesis_block(self):
        """
        创建创世区块，并将其添加到链中
        """
        genesis_block = Block(0, time(), "Genesis Block", "0")
        genesis_block.mine_block(self.difficulty)  # 挖矿
        self.chain.append(genesis_block)

    def add_block(self, data):
        """
        向链中添加新的区块

        参数:
            data (any): 新区块包含的数据
        """
        previous_block = self.chain[-1]
        new_block = Block(len(self.chain), time(), data, previous_block.hash)
        new_block.mine_block(self.difficulty)  # 挖矿
        self.chain.append(new_block)


# 创建一个区块链实例
blockchain = Blockchain()

# 添加一些数据到区块链中
blockchain.add_block("Transaction Data 1")
blockchain.add_block("Transaction Data 2")
blockchain.add_block("Transaction Data 3")

# 打印区块链中的每个区块的属性
for block in blockchain.chain:
    print("Index:", block.index)
    print("Timestamp:", block.timestamp)
    print("Data:", block.data)
    print("Previous Hash:", block.previous_hash)
    print("Hash:", block.hash)
    print()
