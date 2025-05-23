import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CarbonCalculator extends StatefulWidget {
  const CarbonCalculator({super.key});

  @override
  State<CarbonCalculator> createState() => _CarbonCalculatorState();
}

class _CarbonCalculatorState extends State<CarbonCalculator> {
  List<Map<String, dynamic>> stationData = [];
  String? selectedFrom;
  String? selectedTo;
  String selectedMethod = '捷運';
  List<String> resultCards = [];

  final List<String> methods = ['捷運', 'YouBike + 捷運', '計程車'];

  @override
  void initState() {
    super.initState();
    _fetchStations();
  }

  Future<void> _fetchStations() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.1:8000/stations'),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final stations =
            (jsonData['stations'] as List)
                .map((s) => s as Map<String, dynamic>)
                .toList();
        setState(() {
          stationData = stations;
          if (stationData.isNotEmpty) {
            selectedFrom = stationData.first['name'];
            selectedTo = stationData.last['name'];
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching stations: $e');
    }
  }

  void _simulateCalculation() {
    if (selectedFrom == null || selectedTo == null) return;
    final fromIndex = stationData.indexWhere((s) => s['name'] == selectedFrom);
    final toIndex = stationData.indexWhere((s) => s['name'] == selectedTo);
    if (fromIndex == -1 || toIndex == -1 || fromIndex == toIndex) return;

    int start = fromIndex;
    int end = toIndex;
    if (start > end) {
      final temp = start;
      start = end;
      end = temp;
    }

    double totalDistance = 0;
    int totalTime = 0;
    for (int i = start; i < end; i++) {
      totalDistance += stationData[i]['distance_to_next_km'] ?? 0.0;
      totalTime += ((stationData[i]['travel_time_min'] ?? 0) as num).toInt();
    }

    List<String> results = [];

    final metroEmission = (totalDistance * 50).toStringAsFixed(1);
    results.add(
      '🚇 捷運\n距離：${totalDistance.toStringAsFixed(2)} km\n時間：$totalTime 分\n碳排：約 $metroEmission g CO₂e',
    );

    if (totalDistance > 2.0) {
      final hybridEmission = (totalDistance * 40).toStringAsFixed(1);
      results.add(
        '🚲+🚇 YouBike + 捷運\n距離：${totalDistance.toStringAsFixed(2)} km\n時間：約 ${totalTime + 5} 分\n碳排：約 $hybridEmission g CO₂e',
      );
    }

    if (totalDistance < 10.0) {
      final taxiEmission = (totalDistance * 250).toStringAsFixed(1);
      results.add(
        '🚕 計程車\n距離：${totalDistance.toStringAsFixed(2)} km\n時間：約 ${totalTime - 5} 分\n碳排：約 $taxiEmission g CO₂e\n⚠️ 碳排高',
      );
    }

    setState(() {
      resultCards = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('碳足跡即時換算'),
        backgroundColor: Colors.green[400],
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF0F9F0),
      body:
          stationData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🚶‍♂️ 起訖站與交通方式',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: selectedFrom,
                                      isExpanded: true,
                                      items:
                                          stationData
                                              .map<DropdownMenuItem<String>>(
                                                (s) => DropdownMenuItem<String>(
                                                  value: s['name'] as String,
                                                  child: Text(
                                                    s['name'] as String,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged:
                                          (value) => setState(
                                            () => selectedFrom = value,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.arrow_forward),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButton<String>(
                                      value: selectedTo,
                                      isExpanded: true,
                                      items:
                                          stationData
                                              .map<DropdownMenuItem<String>>(
                                                (s) => DropdownMenuItem<String>(
                                                  value: s['name'] as String,
                                                  child: Text(
                                                    s['name'] as String,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged:
                                          (value) => setState(
                                            () => selectedTo = value,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              DropdownButton<String>(
                                value: selectedMethod,
                                isExpanded: true,
                                items:
                                    methods
                                        .map(
                                          (m) => DropdownMenuItem<String>(
                                            value: m,
                                            child: Text(m),
                                          ),
                                        )
                                        .toList(),
                                onChanged:
                                    (value) => setState(
                                      () =>
                                          selectedMethod =
                                              value ?? methods.first,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.calculate),
                                label: const Text('立即換算'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                ),
                                onPressed: _simulateCalculation,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (resultCards.isNotEmpty)
                        const Text(
                          '📊 換算結果',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 12),
                      ...resultCards.map(
                        (result) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            result,
                            style: const TextStyle(fontSize: 16, height: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
