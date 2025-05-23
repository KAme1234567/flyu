import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/route_planner.dart';
import 'pages/carbon_calculator.dart';
import 'pages/green_points.dart';
import 'pages/dashboard.dart';
import 'pages/esg_report.dart';
import 'pages/user_profile.dart';

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

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    RoutePlanner(),
    CarbonCalculator(),
    GreenPointsPage(),
    DashboardPage(),
    ESGReportPage(),
    UserProfilePage(), // index = 6
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // 關閉 Drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GreenWay 綠跡通')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.green),
              accountName: const Text('使用者名稱'),
              accountEmail: const Text('等級：綠能小尖兵\n碳排：123.4 kg CO₂e'),
              currentAccountPicture: GestureDetector(
                onTap: () => _onItemTap(6),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.green),
                ),
              ),
              onDetailsPressed: () => _onItemTap(6),
            ),
            ListTile(title: const Text('首頁'), onTap: () => _onItemTap(0)),
            ListTile(title: const Text('多式聯運路線規劃'), onTap: () => _onItemTap(1)),
            ListTile(title: const Text('碳足跡即時換算'), onTap: () => _onItemTap(2)),
            ListTile(title: const Text('綠點累積與兌換'), onTap: () => _onItemTap(3)),
            ListTile(title: const Text('個人碳排儀表板'), onTap: () => _onItemTap(4)),
            ListTile(
              title: const Text('企業 ESG 連動'),
              onTap: () => _onItemTap(5),
            ),
          ],
        ),
      ),
      body: Center(child: _pages[_selectedIndex]),
    );
  }
}
