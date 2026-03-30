import logging
import os
from datetime import datetime

# 创建日志目录
log_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), 'logs')
if not os.path.exists(log_dir):
    os.makedirs(log_dir)

# 日志文件名
log_file = os.path.join(log_dir, f'{datetime.now().strftime("%Y-%m-%d")}.log')

# 配置日志
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file),
        logging.StreamHandler()
    ]
)

# 创建日志记录器
def get_logger(name):
    return logging.getLogger(name)
