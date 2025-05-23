import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flyu/globals/user_session.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> trips = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchTrips();
  }

  Future<void> _fetchTrips() async {
    final userId = UserSession.userId;
    if (userId == null) {
      setState(() {
        loading = false;
        error = '尚未登入';
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.1:8000/users/$userId/trips'),
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          trips = data.cast<Map<String, dynamic>>();
          loading = false;
        });
      } else {
        setState(() {
          error = '取得資料失敗 (${response.statusCode})';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = '無法連線到伺服器';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (error != null) {
      return Center(
        child: Text(error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (trips.isEmpty) {
      return const Center(child: Text('🚶 尚無任何碳足跡紀錄'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${trip['transport_type']}：${trip['start_location']} → ${trip['end_location']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '距離：${trip['distance_km']} km  | 排放：${trip['co2_emission_g']} g CO₂e',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    trip['trip_time'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
