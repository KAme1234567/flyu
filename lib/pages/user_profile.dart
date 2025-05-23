import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flyu/globals/user_session.dart';

class UserProfilePage extends StatefulWidget {
  final String userName;
  final VoidCallback onLogout;

  const UserProfilePage({
    super.key,
    required this.userName,
    required this.onLogout,
  });

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? summary;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  Future<void> _fetchSummary() async {
    final userId = UserSession.userId;
    if (userId == null) {
      setState(() {
        error = '尚未登入';
        loading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.1:8000/users/$userId/summary'),
        headers: {'accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          summary = data;
          loading = false;
        });
      } else {
        setState(() {
          error = '取得用戶摘要失敗 (${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = '無法連線到伺服器';
        loading = false;
      });
    }
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('修改個人資料功能待實作')));
  }

  void _changePassword(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('變更密碼功能待實作')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F0),
      appBar: AppBar(
        title: const Text('👤 用戶資訊'),
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            loading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileCard(summary: summary!),
                    const SizedBox(height: 24),
                    const Text(
                      '⚙️ 設定項目',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.edit,
                              color: Colors.green,
                            ),
                            title: const Text('修改個人資料'),
                            onTap: () => _editProfile(context),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.lock,
                              color: Colors.green,
                            ),
                            title: const Text('變更密碼'),
                            onTap: () => _changePassword(context),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ),
                            title: const Text('登出帳號'),
                            onTap: widget.onLogout,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final Map<String, dynamic> summary;

  const _ProfileCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.person, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Text(
                  'ID：${summary['user_id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.emoji_events, color: Colors.orange),
                SizedBox(width: 8),
                Text('目前等級：Lv.3 - 綠能小尖兵'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.cloud, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text('累積碳排量：${summary['total_emission_g']} g CO₂e'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.eco, color: Colors.green),
                const SizedBox(width: 8),
                Text('綠點：${summary['total_points']} 點'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
