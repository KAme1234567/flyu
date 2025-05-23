import 'package:flutter/material.dart';

class CarbonCalculator extends StatelessWidget {
  const CarbonCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🌍 碳足跡即時換算頁面\n展示每條路線碳排與平衡建議',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
