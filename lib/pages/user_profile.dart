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
      appBar: AppBar(title: const Text('👤 用戶資訊')),
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
                    Text(
                      '使用者 ID：${summary?['user_id']}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 12),
                    const Text('目前等級：Lv.3 - 綠能小尖兵'),
                    const SizedBox(height: 12),
                    Text('累積碳排量：${summary?['total_emission_g']} g CO₂e'),
                    const SizedBox(height: 12),
                    Text('綠點：${summary?['total_points']} 點'),
                    const Divider(height: 32),
                    const Text('⚙️ 設定項目', style: TextStyle(fontSize: 18)),
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('修改個人資料'),
                      onTap: () => _editProfile(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.lock),
                      title: const Text('變更密碼'),
                      onTap: () => _changePassword(context),
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('登出帳號'),
                      onTap: widget.onLogout,
                    ),
                  ],
                ),
      ),
    );
  }
}
