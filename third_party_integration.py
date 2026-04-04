import requests
import json
from typing import Dict, List, Optional, Tuple
from datetime import datetime

class ZhaopinIntegration:
    """智联招聘API集成（国内免费）"""
    
    def __init__(self):
        self.base_url = "https://fe-api.zhaopin.com/c/i"
    
    def search_jobs(self, keywords: str, location: str = None, 
                   salary_min: int = None, salary_max: int = None,
                   job_type: str = None, limit: int = 10) -> Tuple[bool, List[Dict]]:
        """搜索职位"""
        try:
            params = {
                "start": 0,
                "pageSize": limit,
                "key": keywords
            }
            
            if location:
                params["city"] = location
            
            response = requests.get(
                f"{self.base_url}/jobs",
                params=params
            )
            
            if response.status_code == 200:
                data = response.json()
                jobs = data.get("data", {}).get("results", [])
                formatted_jobs = []
                for job in jobs:
                    formatted_jobs.append({
                        "id": job.get("number"),
                        "title": job.get("jobName"),
                        "company": job.get("company"),
                        "salary": job.get("salary"),
                        "location": job.get("city"),
                        "description": job.get("jobDescription"),
                        "url": job.get("positionURL")
                    })
                return True, formatted_jobs
            else:
                return False, []
        except Exception as e:
            return False, []


class MoocIntegration:
    """中国大学MOOC集成（国内免费）"""
    
    def __init__(self):
        self.base_url = "https://www.icourse163.org"
    
    def search_courses(self, keywords: str, skill_level: str = None, 
                     language: str = None, limit: int = 10) -> Tuple[bool, List[Dict]]:
        """搜索课程"""
        try:
            params = {
                "query": keywords,
                "pageIndex": 1,
                "pageSize": limit
            }
            
            response = requests.get(
                f"{self.base_url}/web/j/mocSearchBean.getMocSearchResult.rpc",
                params=params
            )
            
            if response.status_code == 200:
                data = response.json()
                courses = data.get("result", {}).get("list", [])
                formatted_courses = []
                for course in courses:
                    formatted_courses.append({
                        "id": course.get("id"),
                        "title": course.get("name"),
                        "provider": course.get("schoolName"),
                        "description": course.get("description"),
                        "skill_level": course.get("level"),
                        "url": f"{self.base_url}/course/{course.get('id')}"
                    })
                return True, formatted_courses
            else:
                return False, []
        except Exception as e:
            return False, []


class ZhihuIntegration:
    """知乎集成（国内免费，用于职业建议和社区）"""
    
    def __init__(self):
        self.base_url = "https://www.zhihu.com"
    
    def search_questions(self, keywords: str, limit: int = 10) -> Tuple[bool, List[Dict]]:
        """搜索相关问题"""
        try:
            params = {
                "q": keywords,
                "limit": limit
            }
            
            response = requests.get(
                f"{self.base_url}/api/v4/search_v3",
                params=params
            )
            
            if response.status_code == 200:
                data = response.json()
                questions = data.get("data", [])
                formatted_questions = []
                for item in questions:
                    if item.get("type") == "answer":
                        formatted_questions.append({
                            "id": item.get("object", {}).get("question", {}).get("id"),
                            "title": item.get("object", {}).get("question", {}).get("title"),
                            "content": item.get("object", {}).get("content"),
                            "url": f"{self.base_url}/question/{item.get('object', {}).get('question', {}).get('id')}"
                        })
                return True, formatted_questions
            else:
                return False, []
        except Exception as e:
            return False, []


class CareerAssessmentIntegration:
    """国内职业测评服务集成"""
    
    def __init__(self):
        self.base_url = "https://api.51job.com"
    
    def get_assessment_types(self) -> Tuple[bool, List[Dict]]:
        """获取测评类型"""
        try:
            # 模拟数据，实际项目中可以接入国内免费测评服务
            assessment_types = [
                {"id": "1", "name": "职业兴趣测评", "description": "了解您的职业兴趣倾向"},
                {"id": "2", "name": "性格测评", "description": "了解您的性格特点"},
                {"id": "3", "name": "技能评估", "description": "评估您的专业技能水平"},
                {"id": "4", "name": "职业价值观测评", "description": "了解您的职业价值观"}
            ]
            return True, assessment_types
        except Exception as e:
            return False, []
    
    def get_assessment_result(self, assessment_id: str, user_answers: List[Dict]) -> Tuple[bool, Dict]:
        """获取测评结果"""
        try:
            # 模拟数据，实际项目中可以接入国内免费测评服务
            results = {
                "1": {
                    "title": "职业兴趣测评结果",
                    "result": "您适合从事创意性工作，如设计、营销等",
                    "suggestions": ["可以考虑广告设计、市场营销等方向", "建议提升创意能力和表达能力"]
                },
                "2": {
                    "title": "性格测评结果",
                    "result": "您是一个外向、乐观的人，善于与人沟通",
                    "suggestions": ["适合从事销售、客户服务等工作", "建议发挥您的人际交往优势"]
                },
                "3": {
                    "title": "技能评估结果",
                    "result": "您在计算机技能方面表现优秀",
                    "suggestions": ["可以考虑IT相关工作", "建议进一步提升编程能力"]
                },
                "4": {
                    "title": "职业价值观测评结果",
                    "result": "您重视工作中的成就感和个人成长",
                    "suggestions": ["选择能够提供成长空间的工作", "关注工作内容的挑战性"]
                }
            }
            return True, results.get(assessment_id, {"title": "测评结果", "result": "暂无结果", "suggestions": []})
        except Exception as e:
            return False, {"error": str(e)}


class SkillCertificationIntegration:
    """国内技能认证服务集成"""
    
    def __init__(self):
        self.base_url = "https://api.chinaskills.com"
    
    def get_available_certifications(self, skill_category: str = None) -> Tuple[bool, List[Dict]]:
        """获取可用的认证"""
        try:
            # 模拟数据，实际项目中可以接入国内免费认证服务
            certifications = [
                {
                    "id": "1",
                    "name": "计算机等级考试",
                    "category": "IT技能",
                    "description": "全国计算机等级考试，证明计算机操作能力",
                    "url": "https://ncre.neea.edu.cn"
                },
                {
                    "id": "2",
                    "name": "普通话水平测试",
                    "category": "语言能力",
                    "description": "普通话水平等级证书，证明语言能力",
                    "url": "https://www.cltt.org"
                },
                {
                    "id": "3",
                    "name": "职业资格证书",
                    "category": "专业技能",
                    "description": "各类职业资格证书，证明专业能力",
                    "url": "https://www.osta.org.cn"
                }
            ]
            if skill_category:
                certifications = [c for c in certifications if c.get("category") == skill_category]
            return True, certifications
        except Exception as e:
            return False, []


class ThirdPartyIntegrationManager:
    """第三方服务集成管理器"""
    
    def __init__(self):
        self.zhaopin = ZhaopinIntegration()
        self.mooc = MoocIntegration()
        self.zhihu = ZhihuIntegration()
        self.career_assessment = CareerAssessmentIntegration()
        self.skill_certification = SkillCertificationIntegration()
    
    def search_jobs_all_platforms(self, keywords: str, location: str = None, 
                                 limit: int = 10) -> List[Dict]:
        """在所有平台搜索职位"""
        all_jobs = []
        
        # 从智联招聘搜索
        success, jobs = self.zhaopin.search_jobs(keywords, location, limit=limit)
        if success:
            all_jobs.extend([{"source": "智联招聘", **job} for job in jobs])
        
        return all_jobs
    
    def search_courses(self, keywords: str, limit: int = 10) -> List[Dict]:
        """搜索在线课程"""
        all_courses = []
        
        # 从中国大学MOOC搜索
        success, courses = self.mooc.search_courses(keywords, limit=limit)
        if success:
            all_courses.extend([{"source": "中国大学MOOC", **course} for course in courses])
        
        return all_courses
    
    def search_career_advice(self, keywords: str, limit: int = 5) -> List[Dict]:
        """搜索职业建议"""
        all_advice = []
        
        # 从知乎搜索
        success, advice = self.zhihu.search_questions(keywords, limit=limit)
        if success:
            all_advice.extend([{"source": "知乎", **item} for item in advice])
        
        return all_advice