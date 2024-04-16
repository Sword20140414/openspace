import hashlib
import time

class SHA256HashGenerator:
    def __init__(self, nick):
        """
        初始化 SHA256HashGenerator 类

        Parameters:
            nick (str): 用户的昵称
        """
        self.nick = nick
        self.nonce = 0

    def generate_hash(self, leading_zeros):
        """
        生成 SHA-256 哈希值，并检查是否满足前导零条件

        Parameters:
            leading_zeros (int): 所需的前导零位数

        Returns:
            str: SHA-256 哈希值的十六进制表示
        """
        while True:
            input_string = f"{self.nick}{self.nonce}"  # 构建输入字符串
            sha256_hash = hashlib.sha256()  # 创建 SHA-256 对象
            sha256_hash.update(input_string.encode())  # 更新哈希对象
            hash_result = sha256_hash.hexdigest()  # 获取哈希值的十六进制表示
            if hash_result.startswith('0' * leading_zeros):
                return hash_result, self.nonce
            self.nonce += 1  # 递增 NONCE

if __name__ == '__main__':
    # 用户昵称
    nick = 'sword'

    # 第一个条件：满足 4 个 0 开头的哈希值
    start_time = time.time()
    hash_generator = SHA256HashGenerator(nick)
    hash_result, nonce = hash_generator.generate_hash(4)
    end_time = time.time()
    print(f"满足 4 个 0 开头的哈希值：{hash_result}")
    print(f"花费的时间：{end_time - start_time} 秒")
    print(f"Nonce 值：{nonce}")

    # 第二个条件：满足 5 个 0 开头的哈希值
    start_time = time.time()
    hash_result, nonce = hash_generator.generate_hash(5)
    end_time = time.time()
    print(f"满足 5 个 0 开头的哈希值：{hash_result}")
    print(f"花费的时间：{end_time - start_time} 秒")
    print(f"Nonce 值：{nonce}")
