import 'package:flutter/material.dart';

class ESGReportPage extends StatelessWidget {
  const ESGReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🏢 ESG 報告連動頁面\n整合企業通勤資料供報告產出',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
