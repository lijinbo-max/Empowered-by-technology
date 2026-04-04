# Kubernetes 部署指南

## 📋 前置要求

- Kubernetes 集群 (v1.20+)
- kubectl 命令行工具
- Helm 3 (可选)
- 持久化存储支持

## 🚀 快速部署

### 1. 创建命名空间

```bash
kubectl apply -f namespace.yaml
```

### 2. 创建配置和密钥

```bash
# 创建ConfigMap
kubectl apply -f configmap.yaml

# 创建Secret（请先修改secret.yaml中的敏感信息）
kubectl apply -f secret.yaml
```

### 3. 部署数据库服务

```bash
# 部署MySQL
kubectl apply -f mysql-deployment.yaml

# 部署Redis
kubectl apply -f redis-deployment.yaml

# 部署MinIO
kubectl apply -f minio-deployment.yaml
```

### 4. 部署应用

```bash
kubectl apply -f app-deployment.yaml
```

### 5. 部署监控系统

```bash
# 部署Prometheus
kubectl apply -f prometheus.yaml

# 部署Grafana
kubectl apply -f grafana.yaml
```

### 6. 一键部署所有服务

```bash
kubectl apply -f .
```

## 📊 服务访问

### 应用服务

```bash
# 获取应用URL
kubectl get svc ai-job-helper-service -n ai-job-helper

# 端口转发（本地访问）
kubectl port-forward svc/ai-job-helper-service 8501:80 -n ai-job-helper
```

访问地址: http://localhost:8501

### MinIO控制台

```bash
# 端口转发
kubectl port-forward svc/minio-service 9001:9001 -n ai-job-helper
```

访问地址: http://localhost:9001

- 用户名: minioadmin
- 密码: minioadmin

### Grafana监控

```bash
# 端口转发
kubectl port-forward svc/grafana-service 3000:3000 -n ai-job-helper
```

访问地址: http://localhost:3000

- 用户名: admin
- 密码: admin

### Prometheus

```bash
# 端口转发
kubectl port-forward svc/prometheus-service 9090:9090 -n ai-job-helper
```

访问地址: http://localhost:9090

## 🔧 配置说明

### ConfigMap 配置项

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| ENVIRONMENT | 运行环境 | production |
| DEBUG | 调试模式 | False |
| MYSQL_HOST | MySQL主机 | mysql-service |
| MYSQL_PORT | MySQL端口 | 3306 |
| REDIS_HOST | Redis主机 | redis-service |
| REDIS_PORT | Redis端口 | 6379 |
| MINIO_ENDPOINT | MinIO端点 | minio-service:9000 |

### Secret 配置项

| 配置项 | 说明 |
|--------|------|
| MYSQL_ROOT_PASSWORD | MySQL root密码 |
| MYSQL_USER | MySQL用户名 |
| MYSQL_PASSWORD | MySQL密码 |
| MINIO_ROOT_USER | MinIO用户名 |
| MINIO_ROOT_PASSWORD | MinIO密码 |
| GLM4_API_KEY | GLM-4 API密钥 |

⚠️ **重要**: 在生产环境中，请务必修改所有默认密码和密钥！

## 📈 监控指标

### 应用指标

- HTTP请求总数
- 请求响应时间
- 错误率
- 活跃用户数

### MySQL指标

- 连接数
- 查询性能
- 慢查询数
- 缓冲池使用率

### Redis指标

- 内存使用量
- 键数量
- 命中率
- 连接数

### MinIO指标

- 存储使用量
- 请求速率
- 带宽使用

## 🔍 故障排查

### 查看Pod状态

```bash
kubectl get pods -n ai-job-helper
```

### 查看Pod日志

```bash
# 应用日志
kubectl logs -f deployment/ai-job-helper -n ai-job-helper

# MySQL日志
kubectl logs -f deployment/mysql -n ai-job-helper

# Redis日志
kubectl logs -f deployment/redis -n ai-job-helper

# MinIO日志
kubectl logs -f deployment/minio -n ai-job-helper
```

### 查看事件

```bash
kubectl get events -n ai-job-helper --sort-by='.lastTimestamp'
```

### 进入容器

```bash
# 进入应用容器
kubectl exec -it deployment/ai-job-helper -n ai-job-helper -- /bin/bash

# 进入MySQL容器
kubectl exec -it deployment/mysql -n ai-job-helper -- /bin/bash
```

## 🔄 更新部署

### 更新应用镜像

```bash
# 更新镜像
kubectl set image deployment/ai-job-helper app=ai-job-helper:new-version -n ai-job-helper

# 查看更新状态
kubectl rollout status deployment/ai-job-helper -n ai-job-helper
```

### 回滚部署

```bash
# 查看历史版本
kubectl rollout history deployment/ai-job-helper -n ai-job-helper

# 回滚到上一版本
kubectl rollout undo deployment/ai-job-helper -n ai-job-helper

# 回滚到指定版本
kubectl rollout undo deployment/ai-job-helper --to-revision=2 -n ai-job-helper
```

## 📦 扩缩容

### 手动扩容

```bash
# 扩展到3个副本
kubectl scale deployment ai-job-helper --replicas=3 -n ai-job-helper
```

### 自动扩容 (HPA)

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ai-job-helper-hpa
  namespace: ai-job-helper
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: ai-job-helper
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

```bash
kubectl apply -f hpa.yaml
```

## 🗑️ 清理资源

### 删除所有资源

```bash
kubectl delete -f .
```

### 仅删除应用

```bash
kubectl delete -f app-deployment.yaml
```

### 删除命名空间

```bash
kubectl delete namespace ai-job-helper
```

## 🔐 安全建议

1. **修改默认密码**: 所有服务的默认密码都应修改
2. **使用TLS**: 为Ingress配置HTTPS
3. **网络策略**: 配置NetworkPolicy限制Pod间通信
4. **RBAC**: 配置最小权限的ServiceAccount
5. **镜像安全**: 使用可信镜像源，定期扫描漏洞

## 📚 参考资源

- [Kubernetes官方文档](https://kubernetes.io/docs/)
- [Prometheus文档](https://prometheus.io/docs/)
- [Grafana文档](https://grafana.com/docs/)
- [MinIO文档](https://docs.min.io/)
