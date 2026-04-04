# 构建阶段
FROM python:3.9-slim AS builder

WORKDIR /app

# 安装构建依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# 复制依赖文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir --user -r requirements.txt

# 运行阶段
FROM python:3.9-slim AS runtime

# 设置标签
LABEL maintainer="AI Job Helper Team"
LABEL version="1.0"
LABEL description="AI助残求职辅助工具"

# 创建非root用户
RUN useradd -m -u 1000 appuser

WORKDIR /app

# 安装运行时依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# 从构建阶段复制Python包
COPY --from=builder /root/.local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# 复制应用代码
COPY --chown=appuser:appuser . .

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 8501

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# 运行应用
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
