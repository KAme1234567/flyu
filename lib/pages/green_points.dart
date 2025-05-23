import 'package:flutter/material.dart';

class GreenPointsPage extends StatelessWidget {
  const GreenPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🎁 綠點累積與兌換頁面\n顯示用戶綠點、兌換選項與紀錄',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
