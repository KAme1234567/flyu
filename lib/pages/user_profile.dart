import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('👤 用戶資訊')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('使用者名稱：綠能小尖兵', style: TextStyle(fontSize: 20)),
            SizedBox(height: 12),
            Text('目前等級：Lv.3 - 綠能小尖兵'),
            SizedBox(height: 12),
            Text('累積碳排量：123.4 kg CO₂e'),
            SizedBox(height: 12),
            Text('綠點：280 點'),
            Divider(height: 32),
            Text('⚙️ 設定項目', style: TextStyle(fontSize: 18)),
            ListTile(leading: Icon(Icons.edit), title: Text('修改個人資料')),
            ListTile(leading: Icon(Icons.lock), title: Text('變更密碼')),
            ListTile(leading: Icon(Icons.logout), title: Text('登出帳號')),
          ],
        ),
      ),
    );
  }
}
