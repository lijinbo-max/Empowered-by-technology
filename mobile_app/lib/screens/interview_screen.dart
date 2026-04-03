import 'package:flutter/material.dart';

class InterviewScreen extends StatefulWidget {
  @override
  _InterviewScreenState createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String _selectedType = '技术面试';
  List<String> _interviewTypes = [
    '技术面试',
    '行为面试',
    '案例面试',
    '群面',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('面试模拟'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择面试类型',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: _interviewTypes.map((type) {
                  return RadioListTile(
                    title: Text(type),
                    value: type,
                    groupValue: _selectedType,
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value as String;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 32),
            Text(
              '常见问题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildQuestionCard('请介绍一下你自己'),
                  _buildQuestionCard('你为什么选择我们公司？'),
                  _buildQuestionCard('你的优点和缺点是什么？'),
                  _buildQuestionCard('你如何处理工作中的压力？'),
                  _buildQuestionCard('你对薪资有什么要求？'),
                ],
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // 开始面试模拟
              },
              child: Text('开始面试模拟'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // 查看参考答案
            },
            child: Text('查看参考答案'),
          ),
        ],
      ),
    );
  }
}