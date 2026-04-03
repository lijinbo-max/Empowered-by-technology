import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  List<Post> _posts = [
    Post(
      title: '如何提高面试成功率？',
      content: '大家好，我是一名即将毕业的学生，想请教一下如何提高面试成功率。特别是对于残障人士来说，有什么特别的建议吗？',
      author: '小明',
      date: '2026-04-01',
      likes: 12,
      comments: 5,
    ),
    Post(
      title: '分享一个好用的求职技巧',
      content: '我发现使用STAR法则来回答行为面试问题非常有效。STAR法则是指Situation（情境）、Task（任务）、Action（行动）、Result（结果）。通过这种结构化的回答方式，能够更清晰地展示自己的能力。',
      author: '小红',
      date: '2026-03-30',
      likes: 25,
      comments: 10,
    ),
    Post(
      title: '推荐一些适合残障人士的工作',
      content: '我整理了一些适合残障人士的工作，包括远程工作、自由职业等。希望能够帮助到大家。',
      author: '小李',
      date: '2026-03-28',
      likes: 30,
      comments: 15,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('社区论坛'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 发布新帖子
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          return _buildPostCard(_posts[index]);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post) {
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
            Text(
              post.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.author} · ${post.date}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () {},
                      iconSize: 16,
                    ),
                    Text('${post.likes}'),
                    SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                      iconSize: 16,
                    ),
                    Text('${post.comments}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Post {
  final String title;
  final String content;
  final String author;
  final String date;
  final int likes;
  final int comments;

  Post({
    required this.title,
    required this.content,
    required this.author,
    required this.date,
    required this.likes,
    required this.comments,
  });
}