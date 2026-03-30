import streamlit as st
import os
import time
from dotenv import load_dotenv
from src.database import init_db
from src.app.auth.auth_service import AuthService
from src.app.utils.logger import get_logger

logger = get_logger(__name__)

# 加载环境变量
load_dotenv()

# 初始化数据库
logger.info("Initializing database...")
try:
    init_db()
    logger.info("Database initialized successfully")
except Exception as e:
    logger.error(f"Database initialization error: {str(e)}")

# 页面配置
st.set_page_config(
    page_title="AI助残求职辅助工具",
    page_icon="🤝",
    layout="wide"
)

# 加载CSS样式
with open("src/app/utils/style.css", "r", encoding="utf-8") as f:
    st.markdown(f"<style>{f.read()}</style>", unsafe_allow_html=True)

# 检测设备类型
def get_device_type():
    # 由于Streamlit的request属性可能不可用，使用默认值
    return 'desktop'

# 获取设备类型
device_type = get_device_type()
st.session_state.device_type = device_type

# 无障碍功能设置
if 'font_size' not in st.session_state:
    st.session_state.font_size = "中"
if 'contrast' not in st.session_state:
    st.session_state.contrast = "标准"
if 'text_to_speech' not in st.session_state:
    st.session_state.text_to_speech = False

# 简单的登录表单
st.title("🤝 AI助残求职辅助工具")

# 登录表单
with st.form("login_form"):
    st.subheader("用户登录")
    email = st.text_input("邮箱")
    password = st.text_input("密码", type="password")
    login_button = st.form_submit_button("登录")

# 认证逻辑
if login_button:
    success, result = AuthService.login(email, password)
    if success:
        user = result
        st.session_state["authentication_status"] = True
        st.session_state["name"] = user.name
        st.session_state["username"] = user.email
        st.success(f"登录成功！欢迎回来，{user.name}！")
        # 重新加载页面
        st.rerun()
    else:
        st.error(result)

# 检查认证状态
if "authentication_status" in st.session_state and st.session_state["authentication_status"]:
    name = st.session_state["name"]
    username = st.session_state["username"]
    authentication_status = st.session_state["authentication_status"]
    # 主页面
    st.write(f"欢迎回来，{name}！")
    
    # 侧边栏导航
    st.sidebar.title("导航")
    page = st.sidebar.radio(
        "选择功能",
        ["首页", "个人信息", "简历分析", "职位推荐", "面试模拟"]
    )
    
    # 登出按钮
    if st.sidebar.button("退出"):
        st.session_state["authentication_status"] = False
        st.session_state.pop("name", None)
        st.session_state.pop("username", None)
        st.rerun()
    
    # 首页
    if page == "首页":
        st.header("欢迎使用AI助残求职辅助工具")
        st.write("本工具旨在帮助残障人士更有效地寻找工作机会，提供以下功能：")
        
        col1, col2, col3 = st.columns(3)
        
        with col1:
            st.subheader("📄 简历分析")
            st.write("AI智能分析您的简历，提供优化建议")
        
        with col2:
            st.subheader("💼 职位推荐")
            st.write("根据您的技能和偏好推荐合适的职位")
        
        with col3:
            st.subheader("🎯 面试模拟")
            st.write("模拟面试场景，提供反馈和改进建议")
        
        st.markdown("---")
        st.subheader("最新职位")
        st.write("以下是最新的职位信息：")
        # 这里可以添加职位列表
        
    # 个人信息页面
    elif page == "个人信息":
        st.header("个人信息管理")
        # 个人信息表单
        with st.form("personal_info_form"):
            st.subheader("基本信息")
            name = st.text_input("姓名", value=name)
            gender = st.selectbox("性别", ["", "男", "女"])
            age = st.number_input("年龄", min_value=18, max_value=70)
            disability_type = st.text_input("残疾类型")
            disability_level = st.selectbox("残疾等级", ["", "一级", "二级", "三级", "四级"])
            phone = st.text_input("手机号码")
            address = st.text_area("地址")
            
            st.subheader("教育背景")
            school = st.text_input("学校")
            degree = st.selectbox("学历", ["", "高中", "大专", "本科", "硕士", "博士"])
            major = st.text_input("专业")
            
            st.subheader("工作经验")
            company = st.text_input("公司名称")
            position = st.text_input("职位")
            work_description = st.text_area("工作描述")
            
            submit_button = st.form_submit_button("保存信息")
        
        if submit_button:
            st.success("个人信息保存成功！")
    
    # 简历分析页面
    elif page == "简历分析":
        st.header("简历分析")
        st.write("上传您的简历，AI将为您提供分析和优化建议")
        
        # 文件上传
        uploaded_file = st.file_uploader("选择简历文件", type=["pdf", "doc", "docx"])
        
        if uploaded_file is not None:
            st.success("文件上传成功！")
            # 模拟AI分析
            with st.spinner("AI正在分析您的简历..."):
                time.sleep(2)
            
            st.subheader("分析结果")
            st.write("### 简历评分：85/100")
            
            st.write("### 优势")
            st.write("1. 教育背景完整，专业对口")
            st.write("2. 工作经验丰富，有相关行业经验")
            st.write("3. 技能清单全面，符合职位要求")
            
            st.write("### 改进建议")
            st.write("1. 增加具体的工作成果和量化指标")
            st.write("2. 优化简历格式，提高可读性")
            st.write("3. 突出与目标职位相关的技能和经验")
    
    # 职位推荐页面
    elif page == "职位推荐":
        st.header("职位推荐")
        
        # 职位偏好设置
        with st.form("job_preference_form"):
            st.subheader("职位偏好")
            industry = st.selectbox("行业", ["", "IT/互联网", "教育", "医疗", "金融", "制造业"])
            position = st.text_input("职位")
            salary_min = st.number_input("最低薪资", min_value=0)
            salary_max = st.number_input("最高薪资", min_value=0)
            location = st.text_input("工作地点")
            
            submit_button = st.form_submit_button("保存偏好")
        
        if submit_button:
            st.success("职位偏好保存成功！")
        
        # 推荐职位
        st.subheader("推荐职位")
        # 模拟职位推荐
        jobs = [
            {"title": "软件工程师", "company": "科技公司A", "salary": "15000-25000", "location": "北京"},
            {"title": "数据分析师", "company": "互联网公司B", "salary": "12000-20000", "location": "上海"},
            {"title": "产品经理", "company": "创业公司C", "salary": "18000-28000", "location": "深圳"}
        ]
        
        for job in jobs:
            with st.expander(f"{job['title']} - {job['company']}"):
                st.write(f"薪资：{job['salary']}")
                st.write(f"地点：{job['location']}")
                st.write("职位描述：负责公司产品的设计和开发，与团队合作完成项目目标。")
                st.button("申请职位", key=job['title'])
    
    # 面试模拟页面
    elif page == "面试模拟":
        st.header("面试模拟")
        
        # 选择面试类型
        interview_type = st.selectbox("面试类型", ["技术面试", "行为面试", "情景面试"])
        
        # 开始模拟面试
        if st.button("开始模拟面试"):
            st.session_state["interview_started"] = True
            st.session_state["current_question"] = 0
        
        # 面试问题
        questions = {
            "技术面试": [
                "请介绍一下你最熟悉的编程语言",
                "你如何解决遇到的技术难题？",
                "请解释一下什么是面向对象编程"
            ],
            "行为面试": [
                "请描述一次你面对挑战的经历",
                "你如何与团队成员合作？",
                "请分享一次你解决冲突的经历"
            ],
            "情景面试": [
                "如果你的项目延期了，你会怎么做？",
                "如果客户对你的方案不满意，你会如何处理？",
                "如果团队成员意见分歧，你会如何协调？"
            ]
        }
        
        # 模拟面试流程
        if "interview_started" in st.session_state and st.session_state["interview_started"]:
            current_question = st.session_state["current_question"]
            if current_question < len(questions[interview_type]):
                st.subheader(f"问题 {current_question + 1}")
                st.write(questions[interview_type][current_question])
                
                # 回答输入
                answer = st.text_area("你的回答")
                
                if st.button("提交回答"):
                    # 模拟AI反馈
                    with st.spinner("AI正在分析你的回答..."):
                        time.sleep(1)
                    
                    st.success("回答分析完成！")
                    st.write("### 反馈")
                    st.write("- 回答结构清晰，逻辑连贯")
                    st.write("- 提供了具体的例子，增强了说服力")
                    st.write("- 可以更详细地说明你是如何解决问题的")
                    
                    # 下一个问题
                    st.session_state["current_question"] += 1
                    st.rerun()
            else:
                st.success("面试模拟完成！")
                st.write("### 面试总结")
                st.write("- 整体表现良好，回答问题有条理")
                st.write("- 能够提供具体的例子支持自己的观点")
                st.write("- 建议在技术问题上准备更充分的细节")
                
                if st.button("重新开始"):
                    st.session_state.pop("interview_started", None)
                    st.session_state.pop("current_question", None)
                    st.rerun()
    
    # 无障碍设置
    st.sidebar.title("无障碍设置")
    font_size = st.sidebar.selectbox("字体大小", ["小", "中", "大"], index=["小", "中", "大"].index(st.session_state.font_size))
    if font_size != st.session_state.font_size:
        st.session_state.font_size = font_size
        st.rerun()
    
    contrast = st.sidebar.selectbox("对比度", ["标准", "高对比度"], index=["标准", "高对比度"].index(st.session_state.contrast))
    if contrast != st.session_state.contrast:
        st.session_state.contrast = contrast
        st.rerun()
    
    text_to_speech = st.sidebar.checkbox("文字转语音", value=st.session_state.text_to_speech)
    if text_to_speech != st.session_state.text_to_speech:
        st.session_state.text_to_speech = text_to_speech
        st.rerun()
    
    # 页脚
    st.markdown("---")
    st.write("© 2026 AI助残求职辅助工具 | 为残障人士提供平等的就业机会")

elif "authentication_status" in st.session_state and st.session_state["authentication_status"] == False:
    st.error("用户名或密码错误")
elif "authentication_status" not in st.session_state:
    st.warning("请输入用户名和密码")
