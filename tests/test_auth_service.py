import unittest
from src.app.auth.auth_service import AuthService
from src.database import get_session, User

class TestAuthService(unittest.TestCase):
    def setUp(self):
        # 清理测试数据
        session = get_session()
        try:
            # 删除测试用户
            test_user = session.query(User).filter_by(email="test@example.com").first()
            if test_user:
                session.delete(test_user)
                session.commit()
        finally:
            session.close()
    
    def test_login_with_test_user(self):
        # 测试使用测试用户登录
        success, result = AuthService.login("test@example.com", "123456")
        self.assertTrue(success)
        self.assertEqual(result.email, "test@example.com")
        self.assertEqual(result.name, "测试用户")
    
    def test_login_with_invalid_password(self):
        # 测试使用无效密码登录
        # 先创建测试用户
        AuthService.login("test@example.com", "123456")
        # 然后使用错误密码登录
        success, result = AuthService.login("test@example.com", "wrongpassword")
        self.assertFalse(success)
        self.assertEqual(result, "密码错误")
    
    def test_login_with_nonexistent_user(self):
        # 测试使用不存在的用户登录
        success, result = AuthService.login("nonexistent@example.com", "123456")
        self.assertFalse(success)
        self.assertEqual(result, "用户不存在")
    
    def test_register_new_user(self):
        # 测试注册新用户
        success, result = AuthService.register("newuser@example.com", "新用户", "123456")
        self.assertTrue(success)
        self.assertEqual(result.email, "newuser@example.com")
        self.assertEqual(result.name, "新用户")
    
    def test_register_existing_user(self):
        # 测试注册已存在的用户
        # 先注册用户
        AuthService.register("existing@example.com", "已有用户", "123456")
        # 然后再次注册相同邮箱
        success, result = AuthService.register("existing@example.com", "新名称", "123456")
        self.assertFalse(success)
        self.assertEqual(result, "邮箱已被注册")

if __name__ == "__main__":
    unittest.main()
