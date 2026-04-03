import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ai_job_helper_mobile/providers/auth_provider.dart';
import 'package:ai_job_helper_mobile/providers/theme_provider.dart';
import 'package:ai_job_helper_mobile/screens/login_screen.dart';
import 'package:ai_job_helper_mobile/screens/register_screen.dart';
import 'package:ai_job_helper_mobile/screens/home_screen.dart';
import 'package:ai_job_helper_mobile/screens/profile_screen.dart';
import 'package:ai_job_helper_mobile/screens/job_recommendation_screen.dart';
import 'package:ai_job_helper_mobile/screens/interview_screen.dart';
import 'package:ai_job_helper_mobile/screens/feedback_screen.dart';
import 'package:ai_job_helper_mobile/screens/community_screen.dart';
import 'package:ai_job_helper_mobile/screens/third_party_services_screen.dart';
import 'package:ai_job_helper_mobile/screens/enterprise_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'AI助残求职辅助工具',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/jobs': (context) => JobRecommendationScreen(),
        '/interview': (context) => InterviewScreen(),
        '/feedback': (context) => FeedbackScreen(),
        '/community': (context) => CommunityScreen(),
        '/third-party': (context) => ThirdPartyServicesScreen(),
        '/enterprise': (context) => EnterpriseScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}