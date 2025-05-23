import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F9F0),
      appBar: AppBar(
        title: const Text('碳排社群功能'),
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CarbonSummaryCard(),
            const SizedBox(height: 24),
            const Text(
              '功能選單',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _FunctionButtonGrid(),
          ],
        ),
      ),
    );
  }
}

class _CarbonSummaryCard extends StatelessWidget {
  const _CarbonSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade200, Colors.green.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            children: [
              Icon(Icons.bar_chart, color: Colors.white),
              SizedBox(width: 8),
              Text(
                "1月碳排總覽",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text("🚆 火車：12g", style: TextStyle(color: Colors.white)),
          Text("🚌 公車：48g", style: TextStyle(color: Colors.white)),
          Text("🚇 捷運：64g", style: TextStyle(color: Colors.white)),
          Divider(color: Colors.white70),
          Text(
            "📦 總量：124g",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FunctionButtonGrid extends StatelessWidget {
  final List<_FeatureItem> features = const [
    _FeatureItem("好友排行", Icons.people),
    _FeatureItem("總排行", Icons.leaderboard),
    _FeatureItem("路線記錄", Icons.map),
    _FeatureItem("換取點數", Icons.card_giftcard),
    _FeatureItem("社群", Icons.group),
    _FeatureItem("碳排提醒", Icons.notifications_active),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children:
          features.map((feature) {
            return InkWell(
              onTap: () => _showFeatureModal(context, feature.title),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature.icon, color: Colors.white, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      feature.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  void _showFeatureModal(BuildContext context, String title) {
    final Map<String, String> content = {
      '好友排行':
          '🥇 小綠葉 18.4kg\n🥈 eco小子 16.2kg\n🥉 單車女神 15.7kg\n🏅 綠行者 13.9kg\n🏅 低碳旅人 12.4kg',
      '總排行':
          '🥇 ZeroCarb 402.3kg\n🥈 綠能阿嬤 386.1kg\n🥉 無車族 370.5kg\n🏅 校園減碳社 350.8kg\n🏅 GoGreen隊 340.6kg',
      '路線記錄':
          '📍 5/21 板橋→公館（42g）\n📍 5/20 台中→高雄（105g）\n📍 5/19 淡水→台北（23g）\n📍 5/18 台北→新店（15g）',
      '換取點數':
          '🌱 植樹認證：200點\n🎫 捷運轉乘券：120點\n☕ 咖啡折價券：90點\n🛍 環保袋：80點\n📦 ESG 報告工具：50點',
      '社群': '💬 「怎麼搭配低碳交通？」\n💬 「我用綠點換券了！」\n💬 「希望新增台中路線」\n💬 「哪天會有自行車日？」',
      '碳排提醒':
          '🚨 今天汽車出行：1.2kg\n✅ 昨日捷運：0.8kg\n🎯 本週減碳達標率：87%\n📈 累積減碳量：23.4kg\n📅 月目標：30kg',
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                content[title] ?? '內容準備中...',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('關閉'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureItem {
  final String title;
  final IconData icon;

  const _FeatureItem(this.title, this.icon);
}
