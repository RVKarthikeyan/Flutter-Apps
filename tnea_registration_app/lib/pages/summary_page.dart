import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late Map<String, dynamic> statistics;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.http("13.127.164.143", "/api/api/master/stcount/88888");
    try {
      final response = await http.get(url, headers: {
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNTZlZjAyNDEtODNjOC00YzM5LTgzYzktOTBjZmUxNTRkNjNlIn0sImlhdCI6MTcxNDAzNjM3NSwiZXhwIjoxODk0MDM2Mzc1fQ.24ug5sDqRRA6M8SjLs8OVv90xPNPHjTXK16q0PGj0vQ'
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          statistics = jsonData;

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      // ignore: avoid_print
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  //graph
  List<IndividualData> createIndividualDataList(
      Map<String, dynamic> statistics) {
    List<IndividualData> dataList = [];

    // Map each statistic to its corresponding icon and count
    if (statistics.containsKey('tpcnt')) {
      int count = statistics['tpcnt'][0]['total'] ?? 0;
      dataList.add(IndividualData(x: 0, count: count));
    }

    if (statistics.containsKey('ptot')) {
      int count = statistics['ptot'][0]['totalpaid'] ?? 0;
      dataList.add(IndividualData(x: 1, count: count));
    }

    if (statistics.containsKey('utot')) {
      int count = statistics['utot'][0]['totalupd'] ?? 0;
      dataList.add(IndividualData(x: 2, count: count));
    }

    if (statistics.containsKey('fztot')) {
      int count = statistics['fztot'][0]['totalfz'] ?? 0;
      dataList.add(IndividualData(x: 3, count: count));
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    // Create list of IndividualData using the function
    late List<IndividualData> dataList = createIndividualDataList(statistics);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary Page',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildStatisticCategory('Total Students', statistics['tpcnt']),
                _buildStatisticCategory(
                    'Total Paid Students', statistics['ptot']),
                _buildStatisticCategory(
                    'Total Uploaded Students', statistics['utot']),
                _buildStatisticCategory(
                    'Total Freezed Students', statistics['fztot']),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: SizedBox(
                    height: 300,
                    child: BarChart(
                      BarChartData(
                          barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                getTooltipColor: (group) =>
                                    Theme.of(context).colorScheme.primary,
                              )),
                          maxY: 200000,
                          minY: 0,
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          titlesData: FlTitlesData(
                            show: true,
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: getBottomTitles),
                            ),
                          ),
                          barGroups: dataList
                              .map(
                                (data) =>
                                    BarChartGroupData(x: data.x, barRods: [
                                  BarChartRodData(
                                      backDrawRodData:
                                          BackgroundBarChartRodData(
                                              show: true,
                                              toY: 200000,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                      borderRadius: BorderRadius.circular(4),
                                      width: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      toY: data.count.toDouble())
                                ]),
                              )
                              .toList()),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticCategory(String title, List<dynamic>? data) {
    if (data != null && data.isNotEmpty) {
      Map<String, dynamic> entry = data.first;
      int? parsedValue = entry[getTitleKey(title)];

      if (parsedValue != null) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: ListTile(
                leading: Icon(
                  leadIcon(title),
                  size: 30,
                ),
                title: Text(title),
                trailing: Text(
                  '$parsedValue',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        );
      }
    }

    return ListTile(
      title: Text(title),
      subtitle: const Text('Total: 0 (Invalid or missing data)'),
    );
  }

  IconData leadIcon(String title) {
    if (title == 'Total Students') {
      return Icons.person;
    } else if (title == 'Total Paid Students') {
      return Icons.currency_rupee_rounded;
    } else if (title == 'Total Uploaded Students') {
      return Icons.cloud_upload;
    } else if (title == 'Total Freezed Students') {
      return Icons.verified;
    }
    return Icons.error; // Fallback icon
  }

  String getTitleKey(String title) {
    switch (title) {
      case 'Total Students':
        return 'total';
      case 'Total Paid Students':
        return 'totalpaid';
      case 'Total Uploaded Students':
        return 'totalupd';
      case 'Total Freezed Students':
        return 'totalfz';
      default:
        return '';
    }
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    Widget icon;
    switch (value.toInt()) {
      case 0:
        icon = const Icon(Icons.person);
        break;
      case 1:
        icon = const Icon(Icons.currency_rupee);
        break;
      case 2:
        icon = const Icon(Icons.cloud_upload);
        break;
      case 3:
        icon = const Icon(Icons.verified);
        break;
      default:
        icon = const Icon(Icons.person);
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: icon);
  }
}

class IndividualData {
  final int x;
  final int count;

  IndividualData({required this.x, required this.count});
}
