import 'package:flutter/material.dart';

class ThirdPartyServicesScreen extends StatefulWidget {
  @override
  _ThirdPartyServicesScreenState createState() => _ThirdPartyServicesScreenState();
}

class _ThirdPartyServicesScreenState extends State<ThirdPartyServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第三方服务'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '招聘平台',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard('LinkedIn', Icons.link, Colors.blue),
                _buildServiceCard('Indeed', Icons.work, Colors.green),
              ],
            ),
            SizedBox(height: 32),
            Text(
              '职业测评',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard('性格测试', Icons.person, Colors.purple),
                _buildServiceCard('职业兴趣测试', Icons.interests, Colors.orange),
                _buildServiceCard('能力测试', Icons.brain, Colors.red),
                _buildServiceCard('价值观测试', Icons.favorite, Colors.pink),
              ],
            ),
            SizedBox(height: 32),
            Text(
              '技能认证',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard('认证考试', Icons.assignment, Colors.teal),
                _buildServiceCard('认证记录', Icons.history, Colors.blueGrey),
              ],
            ),
            SizedBox(height: 32),
            Text(
              '在线学习',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard('课程搜索', Icons.search, Colors.indigo),
                _buildServiceCard('学习进度', Icons.timeline, Colors.cyan),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // 打开服务
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}