import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoutePlannerPage extends StatefulWidget {
  const RoutePlannerPage({super.key});

  @override
  State<RoutePlannerPage> createState() => _RoutePlannerPageState();
}

class _RoutePlannerPageState extends State<RoutePlannerPage> {
  List<String> stations = [];
  final List<String> transportModes = ['高鐵', '火車', '捷運', '公車'];
  String? startStation;
  String? endStation;
  String? selectedTransport;
  String? resultText;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStations();
  }

  Future<void> fetchStations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.1:8000/stations'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> stationData = data['stations'];
        setState(() {
          stations = stationData.map((s) => s['name'].toString()).toList();
          loading = false;
        });
      } else {
        setState(() {
          resultText = '取得車站失敗，狀態碼 ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        resultText = '網路錯誤：$e';
        loading = false;
      });
    }
  }

  void calculateRoute() {
    setState(() {
      resultText =
          '🚉 從 $startStation 到 $endStation\n'
          '🚌 交通工具：$selectedTransport\n\n'
          '📏 距離：約 10 公里\n'
          '⏱️ 時間：約 30 分鐘\n'
          '💰 預估票價：約 \$25 元\n'
          '🌿 碳排放量：2.1 kg CO₂e';
    });
  }

  Widget buildDropdownSection({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              hint: const Text('請選擇'),
              onChanged: onChanged,
              items:
                  items
                      .map(
                        (item) =>
                            DropdownMenuItem(value: item, child: Text(item)),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚦 多式聯運路線規劃'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    buildDropdownSection(
                      label: '選擇起點',
                      value: startStation,
                      items: stations,
                      onChanged: (val) => setState(() => startStation = val),
                    ),
                    buildDropdownSection(
                      label: '選擇終點',
                      value: endStation,
                      items: stations,
                      onChanged: (val) => setState(() => endStation = val),
                    ),
                    buildDropdownSection(
                      label: '選擇交通工具',
                      value: selectedTransport,
                      items: transportModes,
                      onChanged:
                          (val) => setState(() => selectedTransport = val),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          (startStation != null &&
                                  endStation != null &&
                                  selectedTransport != null)
                              ? calculateRoute
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('開始計算', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 30),
                    if (resultText != null)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Text(
                              resultText!,
                              style: const TextStyle(fontSize: 16, height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('🚋 確認搭乘'),
                                      content: Text(
                                        '已選擇從 $startStation 到 $endStation\n交通工具為 $selectedTransport',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text('取消'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('✅ 搭乘確認完成'),
                                              ),
                                            );
                                          },
                                          child: const Text('確認'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('確認這班車'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
    );
  }
}
