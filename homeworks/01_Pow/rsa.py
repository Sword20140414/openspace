"""
实践非对称加密 RSA（编程语言不限）：

先生成一个公私钥对
用私钥对符合 POW 4个开头的哈希值的 “昵称 + nonce” 进行私钥签名
用公钥验证
"""

import random
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.backends import default_backend

def generate_keypair():
    # 生成RSA公私钥对
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    public_key = private_key.public_key()
    return public_key, private_key

def sign_message(private_key, message):
    # 对消息进行签名
    hasher = hashes.Hash(hashes.SHA256(), backend=default_backend())
    hasher.update(message.encode())
    digest = hasher.finalize()
    signature = private_key.sign(
        digest,
        padding.PKCS1v15(),
        hashes.SHA256()
    )
    return signature

def verify_signature(public_key, message, signature):
    # 验证签名
    hasher = hashes.Hash(hashes.SHA256(), backend=default_backend())
    hasher.update(message.encode())
    digest = hasher.finalize()
    try:
        public_key.verify(
            signature,
            digest,
            padding.PKCS1v15(),
            hashes.SHA256()
        )
        return True
    except Exception as e:
        return False

# 生成公私钥对
public_key, private_key = generate_keypair()
print("Public Key:", public_key)
print("Private Key:", private_key)

# 模拟计算哈希并找到符合条件的nonce
nickname = "Alice"
nonce = ""
while True:
    nonce = str(random.randint(0, 99999))
    hash_input = nickname + nonce
    hasher = hashes.Hash(hashes.SHA256(), backend=default_backend())
    hasher.update(hash_input.encode())
    hash_value = hasher.finalize()
    if hash_value.hex().startswith("4"):
        break

message = nickname + nonce
print("Message:", message)

# 用私钥对消息进行签名
signature = sign_message(private_key, message)
print("Signature:", signature.hex())

# 用公钥验证签名
is_valid = verify_signature(public_key, message, signature)
if is_valid:
    print("Signature is valid.")
else:
    print("Signature is invalid.")
