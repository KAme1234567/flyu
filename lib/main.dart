import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/route_planner.dart';
import 'pages/carbon_calculator.dart';
import 'pages/green_points.dart';
import 'pages/dashboard.dart';
import 'pages/esg_report.dart';
import 'pages/user_profile.dart' as profile;
import 'widgets/side_drawer.dart'; // ✅ 必須加上這行

void main() {
  runApp(const GreenWayApp());
}

class GreenWayApp extends StatelessWidget {
  const GreenWayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenWay 綠跡通',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLoggedIn = false;
  String currentUser = '';

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  List<Widget> get _pages => [
    const HomeScreen(),
    const RoutePlannerPage(),
    const CarbonCalculator(),
    const GreenPointsPage(),
    const DashboardPage(),
    const ESGReportPage(),
    profile.UserProfilePage(
      userName: currentUser,
      onLogout: () {
        setState(() {
          isLoggedIn = false;
          currentUser = '';
          _selectedIndex = 0;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已登出')));
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenWay 綠跡通')),
      drawer: SideDrawer(
        isLoggedIn: isLoggedIn,
        currentUser: currentUser,
        onLoginSuccess: (username) {
          setState(() {
            isLoggedIn = true;
            currentUser = username;
            _selectedIndex = 6;
          });
        },
        onTapItem: _onItemTap,
      ),
      body: _pages[_selectedIndex],
    );
  }
}
