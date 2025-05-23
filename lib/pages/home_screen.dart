import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _InfoCard(
            title: '🌤️ 今日天氣',
            content: '氣溫 26°C · 晴時多雲\n空氣品質良好，適合搭乘自行車通勤',
          ),
          const SizedBox(height: 12),
          _InfoCard(
            title: '📅 今日排程',
            content: '',
            child: const _TodayScheduleList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: _InfoCard(
                    title: '🌱 本日碳排量',
                    content: '2.38 kg CO₂e\n較昨日 -0.9%',
                    compact: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 160,
                  child: _InfoCard(
                    title: '🎯 活動',
                    content: '【低碳挑戰】\n今日已完成「多式轉乘」目標',
                    compact: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _BottomReminderCard(),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final bool compact;
  final Widget? child;

  const _InfoCard({
    required this.title,
    required this.content,
    this.compact = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          if (content.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                content,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 15),
              ),
            ),
          if (child != null)
            Padding(padding: const EdgeInsets.only(top: 12), child: child!),
        ],
      ),
    );
  }
}

class _TodayScheduleList extends StatefulWidget {
  const _TodayScheduleList();

  @override
  State<_TodayScheduleList> createState() => _TodayScheduleListState();
}

class _TodayScheduleListState extends State<_TodayScheduleList> {
  final List<_Trip> trips = [
    _Trip('捷運 → 台北車站'),
    _Trip('高鐵 → 台中站'),
    _Trip('公車轉乘 → 公司'),
  ];

  @override
  void initState() {
    super.initState();
    for (var trip in trips) {
      trip.initCountdown(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (var trip in trips) {
      trip.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          trips.map((trip) {
            final minutes = trip.remaining ~/ 60;
            final seconds = trip.remaining % 60;

            return Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.train, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        trip.label,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      trip.remaining > 0
                          ? '倒數 ${minutes}分${seconds.toString().padLeft(2, '0')}秒'
                          : '✅ 已抵達',
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            trip.remaining > 0
                                ? Colors.black87
                                : Colors.green[700],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
              ],
            );
          }).toList(),
    );
  }
}

class _Trip {
  final String label;
  late int remaining;
  Timer? _timer;

  _Trip(this.label) {
    remaining = Random().nextInt(61) + 10; // 10~70 秒
  }

  void initCountdown(VoidCallback updateUI) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remaining > 0) {
        remaining--;
        updateUI();
      } else {
        _timer?.cancel();
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}

class _BottomReminderCard extends StatelessWidget {
  const _BottomReminderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // Text(
          //   '💚 綠點進度',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.green,
          //   ),
          // ),
          SizedBox(height: 0),
          Text('你的綠點：230 點', style: TextStyle(fontSize: 15)),
          SizedBox(height: 4),
          Text(
            '下個目標：🌱 植樹認證（還需 70 點）',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
