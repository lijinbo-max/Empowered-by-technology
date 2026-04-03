from sqlalchemy import create_engine, Column, Integer, String, Text, Date, ForeignKey, Boolean, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from datetime import datetime
import os
from dotenv import load_dotenv

# 加载环境变量
load_dotenv()

# 从环境变量获取数据库URL，默认使用SQLite
DATABASE_URL = os.getenv('DATABASE_URL', 'sqlite:///job_helper.db')

# 创建数据库引擎
engine = create_engine(DATABASE_URL, echo=False)

# 创建会话工厂
Session = sessionmaker(bind=engine)

# 创建基类
Base = declarative_base()

# 用户模型
class User(Base):
    __tablename__ = 'users'
    
    id = Column(Integer, primary_key=True)
    email = Column(String(100), unique=True, nullable=False)
    name = Column(String(100), nullable=False)
    password = Column(String(200), nullable=False)
    disabled = Column(Boolean, default=False)
    
    # 关系
    personal_info = relationship('PersonalInfo', back_populates='user', uselist=False)
    education = relationship('Education', back_populates='user')
    work_experience = relationship('WorkExperience', back_populates='user')
    job_preferences = relationship('JobPreference', back_populates='user', uselist=False)
    feedback = relationship('Feedback', back_populates='user')
    community_posts = relationship('CommunityPost', back_populates='user')

# 个人信息模型
class PersonalInfo(Base):
    __tablename__ = 'personal_info'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    phone = Column(String(20))
    disability_type = Column(String(50))
    disability_level = Column(String(20))
    
    # 关系
    user = relationship('User', back_populates='personal_info')

# 教育背景模型
class Education(Base):
    __tablename__ = 'education'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    education_level = Column(String(50), nullable=False)
    school = Column(String(100), nullable=False)
    major = Column(String(100))
    graduation_year = Column(Integer)
    
    # 关系
    user = relationship('User', back_populates='education')

# 工作经验模型
class WorkExperience(Base):
    __tablename__ = 'work_experience'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    company = Column(String(100), nullable=False)
    position = Column(String(100), nullable=False)
    start_date = Column(Date)
    end_date = Column(Date)
    responsibilities = Column(Text)
    
    # 关系
    user = relationship('User', back_populates='work_experience')

# 职位偏好模型
class JobPreference(Base):
    __tablename__ = 'job_preferences'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    job_category = Column(String(50))
    location = Column(String(100))
    salary_range = Column(String(50))
    work_type = Column(String(50))
    
    # 关系
    user = relationship('User', back_populates='job_preferences')

# 职位模型
class Job(Base):
    __tablename__ = 'jobs'
    
    id = Column(Integer, primary_key=True)
    title = Column(String(100), nullable=False)
    company = Column(String(100), nullable=False)
    location = Column(String(100))
    salary = Column(String(50))
    description = Column(Text)
    category = Column(String(50))
    work_type = Column(String(50))

# 简历模型
class Resume(Base):
    __tablename__ = 'resumes'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    content = Column(Text, nullable=False)
    file_name = Column(String(100))
    upload_date = Column(Date)

# 用户反馈模型
class Feedback(Base):
    __tablename__ = 'feedback'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    type = Column(String(50), nullable=False)  # 反馈类型：bug, suggestion, question, etc.
    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.now)
    status = Column(String(50), default='pending')  # 状态：pending, processing, resolved
    
    # 关系
    user = relationship('User', back_populates='feedback')

# 社区帖子模型
class CommunityPost(Base):
    __tablename__ = 'community_posts'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    title = Column(String(200), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.now)
    views = Column(Integer, default=0)
    likes = Column(Integer, default=0)
    
    # 关系
    user = relationship('User', back_populates='community_posts')
    comments = relationship('CommunityComment', back_populates='post')

# 社区评论模型
class CommunityComment(Base):
    __tablename__ = 'community_comments'
    
    id = Column(Integer, primary_key=True)
    post_id = Column(Integer, ForeignKey('community_posts.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.now)
    
    # 关系
    post = relationship('CommunityPost', back_populates='comments')
    user = relationship('User')

# 功能使用统计模型
class FeatureUsage(Base):
    __tablename__ = 'feature_usage'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    feature_name = Column(String(100), nullable=False)
    usage_count = Column(Integer, default=0)
    last_used = Column(DateTime, default=datetime.now)
    
    # 关系
    user = relationship('User')

# 第三方服务集成模型
class ThirdPartyIntegration(Base):
    __tablename__ = 'third_party_integrations'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    platform = Column(String(50), nullable=False)  # 平台名称：linkedin, indeed, etc.
    access_token = Column(Text)  # 访问令牌
    refresh_token = Column(Text)  # 刷新令牌
    token_expires_at = Column(DateTime)  # 令牌过期时间
    integration_data = Column(Text)  # 其他集成数据（JSON格式）
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # 关系
    user = relationship('User')

# 职业测评记录模型
class CareerAssessment(Base):
    __tablename__ = 'career_assessments'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    assessment_type = Column(String(50), nullable=False)  # 测评类型
    assessment_data = Column(Text)  # 测评数据（JSON格式）
    results = Column(Text)  # 测评结果（JSON格式）
    status = Column(String(50), default='pending')  # 状态：pending, completed, failed
    created_at = Column(DateTime, default=datetime.now)
    completed_at = Column(DateTime)
    
    # 关系
    user = relationship('User')

# 技能认证记录模型
class SkillCertification(Base):
    __tablename__ = 'skill_certifications'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    certification_name = Column(String(200), nullable=False)
    certification_provider = Column(String(100))  # 认证提供者
    certification_level = Column(String(50))  # 认证级别
    issue_date = Column(Date)
    expiry_date = Column(Date)
    certificate_url = Column(String(500))  # 证书链接
    status = Column(String(50), default='active')  # 状态：active, expired, revoked
    created_at = Column(DateTime, default=datetime.now)
    
    # 关系
    user = relationship('User')

# 在线学习课程记录模型
class OnlineCourse(Base):
    __tablename__ = 'online_courses'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    course_name = Column(String(200), nullable=False)
    course_provider = Column(String(100))  # 课程提供者
    course_url = Column(String(500))  # 课程链接
    skill_level = Column(String(50))  # 技能级别
    progress = Column(Integer, default=0)  # 进度百分比
    status = Column(String(50), default='enrolled')  # 状态：enrolled, in_progress, completed
    enrolled_at = Column(DateTime, default=datetime.now)
    completed_at = Column(DateTime)
    
    # 关系
    user = relationship('User')

# 企业模型
class Company(Base):
    __tablename__ = 'companies'
    
    id = Column(Integer, primary_key=True)
    name = Column(String(200), nullable=False)
    industry = Column(String(100))
    size = Column(String(50))  # 企业规模
    website = Column(String(200))
    description = Column(Text)
    subscription_plan = Column(String(50), default='basic')  # 订阅计划：basic, pro, enterprise
    subscription_expires_at = Column(DateTime)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # 关系
    users = relationship('CompanyUser', back_populates='company')
    teams = relationship('Team', back_populates='company')

# 企业用户关联模型
class CompanyUser(Base):
    __tablename__ = 'company_users'
    
    id = Column(Integer, primary_key=True)
    company_id = Column(Integer, ForeignKey('companies.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    role = Column(String(50), default='member')  # 角色：admin, manager, member
    department = Column(String(100))
    position = Column(String(100))
    joined_at = Column(DateTime, default=datetime.now)
    is_active = Column(Boolean, default=True)
    
    # 关系
    company = relationship('Company', back_populates='users')
    user = relationship('User')

# 团队模型
class Team(Base):
    __tablename__ = 'teams'
    
    id = Column(Integer, primary_key=True)
    company_id = Column(Integer, ForeignKey('companies.id'), nullable=False)
    name = Column(String(200), nullable=False)
    description = Column(Text)
    created_by = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # 关系
    company = relationship('Company', back_populates='teams')
    members = relationship('TeamMember', back_populates='team')
    shared_resources = relationship('SharedResource', back_populates='team')

# 团队成员模型
class TeamMember(Base):
    __tablename__ = 'team_members'
    
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    role = Column(String(50), default='member')  # 角色：admin, member
    joined_at = Column(DateTime, default=datetime.now)
    
    # 关系
    team = relationship('Team', back_populates='members')
    user = relationship('User')

# 共享资源模型
class SharedResource(Base):
    __tablename__ = 'shared_resources'
    
    id = Column(Integer, primary_key=True)
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    resource_type = Column(String(50), nullable=False)  # 资源类型：resume, template, job_posting
    resource_name = Column(String(200), nullable=False)
    resource_data = Column(Text)  # 资源数据（JSON格式）
    created_by = Column(Integer, ForeignKey('users.id'))
    created_at = Column(DateTime, default=datetime.now)
    updated_at = Column(DateTime, default=datetime.now, onupdate=datetime.now)
    
    # 关系
    team = relationship('Team', back_populates='shared_resources')
    creator = relationship('User')

# 数据分析报告模型
class AnalyticsReport(Base):
    __tablename__ = 'analytics_reports'
    
    id = Column(Integer, primary_key=True)
    company_id = Column(Integer, ForeignKey('companies.id'), nullable=False)
    report_type = Column(String(50), nullable=False)  # 报告类型：usage, performance, hiring
    report_data = Column(Text)  # 报告数据（JSON格式）
    generated_at = Column(DateTime, default=datetime.now)
    period_start = Column(DateTime)
    period_end = Column(DateTime)
    
    # 关系
    company = relationship('Company')

# 用户活动日志模型
class ActivityLog(Base):
    __tablename__ = 'activity_logs'
    
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    company_id = Column(Integer, ForeignKey('companies.id'))
    activity_type = Column(String(50), nullable=False)  # 活动类型：login, resume_analysis, job_search, etc.
    activity_data = Column(Text)  # 活动数据（JSON格式）
    ip_address = Column(String(50))
    user_agent = Column(String(500))
    created_at = Column(DateTime, default=datetime.now)
    
    # 关系
    user = relationship('User')
    company = relationship('Company')

# 创建所有表
def init_db():
    Base.metadata.create_all(engine)

# 获取数据库会话
def get_session():
    return Session()

# 数据备份功能
def backup_database(backup_path='backup_job_helper.db'):
    """备份数据库到指定路径"""
    import shutil
    import os
    
    try:
        # 复制数据库文件
        shutil.copy('job_helper.db', backup_path)
        return True, f"数据库备份成功，保存到: {backup_path}"
    except Exception as e:
        return False, f"数据库备份失败: {str(e)}"

# 数据恢复功能
def restore_database(backup_path='backup_job_helper.db'):
    """从指定路径恢复数据库"""
    import shutil
    import os
    
    try:
        # 检查备份文件是否存在
        if not os.path.exists(backup_path):
            return False, f"备份文件不存在: {backup_path}"
        
        # 复制备份文件到数据库位置
        shutil.copy(backup_path, 'job_helper.db')
        return True, f"数据库恢复成功，从: {backup_path}"
    except Exception as e:
        return False, f"数据库恢复失败: {str(e)}"

# 优化数据库查询性能的函数
def optimize_database():
    """优化数据库性能"""
    try:
        # 对于SQLite，执行VACUUM命令来优化数据库
        from sqlalchemy import text
        session = get_session()
        session.execute(text('VACUUM'))
        session.commit()
        session.close()
        return True, "数据库优化成功"
    except Exception as e:
        return False, f"数据库优化失败: {str(e)}"

# 切换到PostgreSQL数据库的函数
def switch_to_postgresql(db_url):
    """切换到PostgreSQL数据库"""
    global engine, Session
    try:
        # 创建PostgreSQL引擎
        from sqlalchemy import create_engine
        engine = create_engine(db_url, echo=False)
        Session = sessionmaker(bind=engine)
        
        # 创建所有表
        Base.metadata.create_all(engine)
        return True, "成功切换到PostgreSQL数据库"
    except Exception as e:
        return False, f"切换到PostgreSQL数据库失败: {str(e)}"

# 云服务集成功能
class CloudStorage:
    """云存储服务类"""
    def __init__(self, provider='aws', **kwargs):
        """初始化云存储服务"""
        self.provider = provider
        self.kwargs = kwargs
        self.client = None
        self._init_client()
    
    def _init_client(self):
        """初始化云存储客户端"""
        try:
            if self.provider == 'aws':
                import boto3
                self.client = boto3.client('s3', 
                                         aws_access_key_id=self.kwargs.get('aws_access_key_id'),
                                         aws_secret_access_key=self.kwargs.get('aws_secret_access_key'),
                                         region_name=self.kwargs.get('region_name', 'us-east-1'))
            elif self.provider == 'google':
                from google.cloud import storage
                self.client = storage.Client.from_service_account_json(self.kwargs.get('service_account_file'))
            elif self.provider == 'azure':
                from azure.storage.blob import BlobServiceClient
                connection_string = self.kwargs.get('connection_string')
                self.client = BlobServiceClient.from_connection_string(connection_string)
        except Exception as e:
            print(f"初始化云存储客户端失败: {str(e)}")
    
    def upload_file(self, local_path, bucket_name, cloud_path):
        """上传文件到云存储"""
        try:
            if self.provider == 'aws':
                self.client.upload_file(local_path, bucket_name, cloud_path)
            elif self.provider == 'google':
                bucket = self.client.get_bucket(bucket_name)
                blob = bucket.blob(cloud_path)
                blob.upload_from_filename(local_path)
            elif self.provider == 'azure':
                blob_client = self.client.get_blob_client(container=bucket_name, blob=cloud_path)
                with open(local_path, "rb") as data:
                    blob_client.upload_blob(data)
            return True, f"文件上传成功: {cloud_path}"
        except Exception as e:
            return False, f"文件上传失败: {str(e)}"
    
    def download_file(self, bucket_name, cloud_path, local_path):
        """从云存储下载文件"""
        try:
            if self.provider == 'aws':
                self.client.download_file(bucket_name, cloud_path, local_path)
            elif self.provider == 'google':
                bucket = self.client.get_bucket(bucket_name)
                blob = bucket.blob(cloud_path)
                blob.download_to_filename(local_path)
            elif self.provider == 'azure':
                blob_client = self.client.get_blob_client(container=bucket_name, blob=cloud_path)
                with open(local_path, "wb") as data:
                    data.write(blob_client.download_blob().readall())
            return True, f"文件下载成功: {local_path}"
        except Exception as e:
            return False, f"文件下载失败: {str(e)}"
    
    def list_files(self, bucket_name, prefix=''):
        """列出云存储中的文件"""
        try:
            files = []
            if self.provider == 'aws':
                response = self.client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
                if 'Contents' in response:
                    files = [obj['Key'] for obj in response['Contents']]
            elif self.provider == 'google':
                bucket = self.client.get_bucket(bucket_name)
                blobs = bucket.list_blobs(prefix=prefix)
                files = [blob.name for blob in blobs]
            elif self.provider == 'azure':
                container_client = self.client.get_container_client(bucket_name)
                blobs = container_client.list_blobs(name_starts_with=prefix)
                files = [blob.name for blob in blobs]
            return True, files
        except Exception as e:
            return False, f"列出文件失败: {str(e)}"

# 云备份和恢复功能
def backup_to_cloud(cloud_provider, bucket_name, **kwargs):
    """备份数据库到云存储"""
    try:
        # 先备份到本地
        backup_path = 'backup_job_helper.db'
        success, message = backup_database(backup_path)
        if not success:
            return success, message
        
        # 上传到云存储
        cloud = CloudStorage(provider=cloud_provider, **kwargs)
        cloud_path = f'backups/job_helper_{datetime.now().strftime("%Y%m%d_%H%M%S")}.db'
        success, message = cloud.upload_file(backup_path, bucket_name, cloud_path)
        return success, message
    except Exception as e:
        return False, f"云备份失败: {str(e)}"

# 从云存储恢复数据库
def restore_from_cloud(cloud_provider, bucket_name, cloud_path, **kwargs):
    """从云存储恢复数据库"""
    try:
        # 从云存储下载备份文件
        local_path = 'temp_backup.db'
        cloud = CloudStorage(provider=cloud_provider, **kwargs)
        success, message = cloud.download_file(bucket_name, cloud_path, local_path)
        if not success:
            return success, message
        
        # 恢复数据库
        return restore_database(local_path)
    except Exception as e:
        return False, f"从云存储恢复失败: {str(e)}"