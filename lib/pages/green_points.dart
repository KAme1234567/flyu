import 'package:flutter/material.dart';

class GreenPointsPage extends StatefulWidget {
  const GreenPointsPage({super.key});

  @override
  State<GreenPointsPage> createState() => _GreenPointsPageState();
}

class _GreenPointsPageState extends State<GreenPointsPage> {
  int userPoints = 230;

  void _attemptExchange(BuildContext context, String title, int cost) {
    if (userPoints >= cost) {
      setState(() => userPoints -= cost);
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder:
            (_) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    '你已成功兌換：\n$title',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('完成'),
                  ),
                ],
              ),
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('綠點不足'),
              content: Text('你目前只有 $userPoints 點，無法兌換「$title」'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('關閉'),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<List<dynamic>> rewards = [
      ['🌱 植樹認證一棵', 200],
      ['🎫 捷運轉乘券', 120],
      ['☕ 永續杯咖啡折價券', 90],
      ['📦 GreenWay 限量徽章', 300],
      ['♻ 可重複環保購物袋', 80],
      ['🍃 永續生活手冊電子版', 50],
      ['🌍 ESG 永續學習課程兌換碼', 180],
      ['🧴 環保洗髮精旅行組', 150],
      ['🥤 自帶杯飲料 50% 折扣券', 60],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('綠點商城'),
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.eco, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  '$userPoints',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0F9F0),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rewards.length,
        itemBuilder: (context, index) {
          final reward = rewards[index];
          return _RewardItem(
            title: reward[0],
            points: reward[1],
            currentPoints: userPoints,
            onExchange: _attemptExchange,
          );
        },
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String title;
  final int points;
  final int currentPoints;
  final void Function(BuildContext, String, int) onExchange;

  const _RewardItem({
    required this.title,
    required this.points,
    required this.currentPoints,
    required this.onExchange,
  });

  @override
  Widget build(BuildContext context) {
    final canExchange = currentPoints >= points;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: canExchange ? Colors.white : Colors.grey[100],
      child: ListTile(
        leading: const Icon(Icons.redeem, color: Colors.green),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text('需要 $points 綠點'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: canExchange ? Colors.green : Colors.grey,
          ),
          onPressed:
              canExchange ? () => onExchange(context, title, points) : null,
          child: const Text('兌換'),
        ),
      ),
    );
  }
}
