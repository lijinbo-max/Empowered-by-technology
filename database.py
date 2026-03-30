from sqlalchemy import create_engine, Column, Integer, String, Text, Date, ForeignKey, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship

# 创建数据库引擎
engine = create_engine('sqlite:///job_helper.db', echo=True)

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

# 创建所有表
def init_db():
    Base.metadata.create_all(engine)

# 获取数据库会话
def get_session():
    return Session()