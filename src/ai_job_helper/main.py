"""AI助残求职辅助工具主入口"""

import subprocess
import sys

def main():
    """启动Streamlit应用"""
    try:
        # 启动Streamlit应用
        subprocess.run([
            sys.executable, "-m", "streamlit", "run", 
            "src/app/main.py"
        ], check=True)
    except subprocess.CalledProcessError as e:
        print(f"启动应用失败: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
