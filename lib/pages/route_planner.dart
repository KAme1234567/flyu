import 'package:flutter/material.dart';

class RoutePlannerPage extends StatefulWidget {
  const RoutePlannerPage({super.key});

  @override
  State<RoutePlannerPage> createState() => _RoutePlannerPageState();
}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
  final List<String> stations = [
    '台北', '板橋', '桃園', '新竹', '苗栗', '台中',
    '彰化', '雲林', '嘉義', '台南', '左營'
  ];

  final List<String> transportModes = ['高鐵', '火車', '捷運', '公車'];

  String? startStation;
  String? endStation;
  String? selectedTransport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('多式聯運路線規劃')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('選擇起點', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: startStation,
              hint: const Text('請選擇出發站'),
              onChanged: (value) => setState(() => startStation = value),
              items: stations.map((station) {
                return DropdownMenuItem(value: station, child: Text(station));
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('選擇終點', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: endStation,
              hint: const Text('請選擇抵達站'),
              onChanged: (value) => setState(() => endStation = value),
              items: stations.map((station) {
                return DropdownMenuItem(value: station, child: Text(station));
              }).toList(),
            ),
            const SizedBox(height: 20),

            const Text('選擇交通工具', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            DropdownButtonFormField<String>(
              value: selectedTransport,
              hint: const Text('請選擇交通工具'),
              onChanged: (value) => setState(() => selectedTransport = value),
              items: transportModes.map((mode) {
                return DropdownMenuItem(value: mode, child: Text(mode));
              }).toList(),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: (startStation != null && endStation != null && selectedTransport != null)
                    ? () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('選擇完成'),
                            content: Text(
                              '從 $startStation 到 $endStation\n交通工具：$selectedTransport',
                              style: const TextStyle(fontSize: 16),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('確定'),
                              )
                            ],
                          ),
                        );
                      }
                    : null,
                child: const Text('開始計算'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
