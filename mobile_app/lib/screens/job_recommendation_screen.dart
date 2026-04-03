import 'package:flutter/material.dart';

class JobRecommendationScreen extends StatefulWidget {
  @override
  _JobRecommendationScreenState createState() => _JobRecommendationScreenState();
}

class _JobRecommendationScreenState extends State<JobRecommendationScreen> {
  List<Job> _jobs = [
    Job(
      title: '软件工程师',
      company: '腾讯科技',
      salary: '20K-30K',
      location: '北京',
      description: '负责公司核心产品的开发和维护，要求熟悉Flutter和Dart语言。',
    ),
    Job(
      title: '前端开发工程师',
      company: '阿里巴巴',
      salary: '18K-25K',
      location: '杭州',
      description: '负责公司网站和移动应用的前端开发，要求熟悉React和Vue。',
    ),
    Job(
      title: '后端开发工程师',
      company: '百度',
      salary: '22K-35K',
      location: '北京',
      description: '负责公司后端服务的开发和维护，要求熟悉Java和Spring框架。',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('职位推荐'),
      ),
      body: ListView.builder(
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          return _buildJobCard(_jobs[index]);
        },
      ),
    );
  }

  Widget _buildJobCard(Job job) {
    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  job.salary,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              job.company,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: Colors.grey,
                ),
                SizedBox(width: 4),
                Text(
                  job.location,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              job.description,
              style: TextStyle(
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 申请职位
                  },
                  child: Text('申请职位'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Job {
  final String title;
  final String company;
  final String salary;
  final String location;
  final String description;

  Job({
    required this.title,
    required this.company,
    required this.salary,
    required this.location,
    required this.description,
  });
}