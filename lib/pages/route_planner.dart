import 'package:flutter/material.dart';

class RoutePlanner extends StatelessWidget {
  const RoutePlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '🚉 多式聯運路線規劃頁面\n此處將顯示路線建議與碳足跡比較',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
