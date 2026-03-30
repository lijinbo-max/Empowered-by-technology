import unittest
from src.app.auth.auth_utils import hash_password, verify_password

class TestAuthUtils(unittest.TestCase):
    def test_hash_password(self):
        # 测试密码哈希
        password = "testpassword"
        hashed = hash_password(password)
        self.assertIsInstance(hashed, str)
        self.assertNotEqual(password, hashed)
    
    def test_verify_password(self):
        # 测试密码验证
        password = "testpassword"
        hashed = hash_password(password)
        # 正确密码
        self.assertTrue(verify_password(password, hashed))
        # 错误密码
        self.assertFalse(verify_password("wrongpassword", hashed))

if __name__ == "__main__":
    unittest.main()
