import unittest
import sys
import os

# 添加项目根目录到Python路径
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

# 发现并运行所有测试
test_loader = unittest.TestLoader()
test_suite = test_loader.discover('tests')

# 运行测试
runner = unittest.TextTestRunner(verbosity=2)
result = runner.run(test_suite)

# 退出码
if result.wasSuccessful():
    sys.exit(0)
else:
    sys.exit(1)
