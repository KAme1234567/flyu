import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flyu/globals/user_session.dart';

class SideDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String currentUser;
  final Function(String username) onLoginSuccess;
  final Function(int index) onTapItem;

  const SideDrawer({
    super.key,
    required this.isLoggedIn,
    required this.currentUser,
    required this.onLoginSuccess,
    required this.onTapItem,
  });

  void _showLoginDialog(BuildContext context) {
    String username = '';
    String password = '';
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('登入'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: '帳號'),
                      onChanged: (val) => username = val,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '密碼'),
                      obscureText: true,
                      onChanged: (val) => password = val,
                    ),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showRegisterDialog(context);
                    },
                    child: const Text('註冊'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final response = await http.post(
                          Uri.parse('http://192.168.137.1:8000/auth/login'),
                          headers: {
                            'accept': 'application/json',
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({
                            'username': username,
                            'password': password,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final userId = data['user_id'];
                          UserSession.setSession(id: userId, name: username);
                          Navigator.pop(context);
                          onLoginSuccess(username);
                        } else {
                          setState(
                            () => errorText = '登入失敗 (${response.statusCode})',
                          );
                        }
                      } catch (e) {
                        setState(() => errorText = '無法連線到伺服器');
                      }
                    },
                    child: const Text('登入'),
                  ),
                ],
              ),
        );
      },
    );
  }

  void _showRegisterDialog(BuildContext context) {
    String username = '';
    String password = '';
    String name = '';
    String email = '';
    String? errorText;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setState) => AlertDialog(
                title: const Text('註冊帳號'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: '使用者名稱'),
                      onChanged: (value) => username = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '密碼'),
                      obscureText: true,
                      onChanged: (value) => password = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '暱稱'),
                      onChanged: (value) => name = value,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: '電子郵件'),
                      onChanged: (value) => email = value,
                    ),
                    if (errorText != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          errorText!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final response = await http.post(
                          Uri.parse('http://192.168.137.1:8000/auth/register'),
                          headers: {
                            'accept': 'application/json',
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode({
                            'username': username,
                            'password': password,
                            'name': name,
                            'email': email,
                          }),
                        );

                        if (response.statusCode == 200) {
                          final data = jsonDecode(response.body);
                          final message = data['message'];
                          Navigator.pop(context);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        } else {
                          setState(
                            () => errorText = '註冊失敗 (${response.statusCode})',
                          );
                        }
                      } catch (e) {
                        setState(() => errorText = '無法連線到伺服器');
                      }
                    },
                    child: const Text('註冊'),
                  ),
                ],
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          isLoggedIn
              ? UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                accountName: Text(currentUser),
                accountEmail: const Text('歡迎使用 GreenWay'),
                currentAccountPicture: GestureDetector(
                  onTap: () => onTapItem(6),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.green),
                  ),
                ),
                onDetailsPressed: () => onTapItem(6),
              )
              : DrawerHeader(
                decoration: const BoxDecoration(color: Colors.green),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '尚未登入',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showLoginDialog(context),
                      icon: const Icon(Icons.login),
                      label: const Text('登入 / 註冊'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('首頁'),
            onTap: () => onTapItem(0),
          ),
          ListTile(
            leading: const Icon(Icons.alt_route),
            title: const Text('多式聯運路線規劃'),
            onTap: () => onTapItem(1),
          ),
          ListTile(
            leading: const Icon(Icons.eco),
            title: const Text('碳足跡即時換算'),
            onTap: () => onTapItem(2),
          ),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: const Text('綠點累積與兌換'),
            onTap: () => onTapItem(3),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_customize),
            title: const Text('個人碳排儀表板'),
            onTap: () => onTapItem(4),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('企業 ESG 連動'),
            onTap: () => onTapItem(5),
          ),
        ],
      ),
    );
  }
}
