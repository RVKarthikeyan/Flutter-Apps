import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GenderWisePage extends StatefulWidget {
  const GenderWisePage({super.key});

  @override
  State<GenderWisePage> createState() => _GenderWisePageState();
}

class _GenderWisePageState extends State<GenderWisePage> {
  late List<Gender> genders;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.http("13.127.164.143", "/api/api/master/stgen/88888");
    try {
      final response = await http.get(url, headers: {
        'x-auth-token':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNTZlZjAyNDEtODNjOC00YzM5LTgzYzktOTBjZmUxNTRkNjNlIn0sImlhdCI6MTcxNDAzNjM3NSwiZXhwIjoxODk0MDM2Mzc1fQ.24ug5sDqRRA6M8SjLs8OVv90xPNPHjTXK16q0PGj0vQ'
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<Gender> fetchedGenders = [];

        for (var eachGender in jsonData['gend']) {
          final gender = Gender(
            shortID: eachGender['_id'],
            genderCount: eachGender['count'],
          );
          fetchedGenders.add(gender);
        }

        setState(() {
          genders = fetchedGenders;
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

  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gender Wise Statistics',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : genders.isEmpty
              ? const Center(
                  child: Text('No data available'),
                )
              : SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: genders.length,
                        itemBuilder: (context, index) {
                          final gender = genders[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Theme.of(context).colorScheme.primary),
                              child: Center(
                                child: ListTile(
                                  leading: _getGenderIcon(gender.shortID),
                                  title: Text(
                                    gender.getFullName(),
                                  ),
                                  trailing: Text(
                                    '${gender.genderCount}',
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                              pieTouchData: PieTouchData(
                                  enabled: true,
                                  touchCallback:
                                      (FlTouchEvent event, pieTouchResponse) {
                                    setState(() {
                                      if (!event.isInterestedForInteractions ||
                                          pieTouchResponse == null ||
                                          pieTouchResponse.touchedSection ==
                                              null) {
                                        touchedIndex = -1;
                                        return;
                                      }
                                      touchedIndex = pieTouchResponse
                                          .touchedSection!.touchedSectionIndex;
                                    });
                                  }),
                              sections: pieChartSection(),
                              sectionsSpace: 2,
                              centerSpaceRadius: 0),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  List<PieChartSectionData> pieChartSection() {
    return List.generate(genders.length, (index) {
      double value = genders[index].genderCount.toDouble();
      final isTouched = index == touchedIndex;
      return PieChartSectionData(
          value: value,
          title: value.toInt().toString(),
          color: genders[index].getColor(),
          showTitle: isTouched ? true : false,
          radius: isTouched ? 170 : 150,
          titleStyle: const TextStyle(fontSize: 30),
          badgeWidget:
              isTouched ? null : _getGenderIcon(genders[index].shortID));
    });
  }

  Widget _getGenderIcon(String shortID) {
    IconData iconData = Icons.person;
    if (shortID.toLowerCase() == 'm') {
      iconData = Icons.male;
    } else if (shortID.toLowerCase() == 'f') {
      iconData = Icons.female;
    }
    return Icon(
      iconData,
      size: 30,
    );
  }
}

class Gender {
  final String shortID;
  final int genderCount;

  Gender({required this.shortID, required this.genderCount});

  String getFullName() {
    if (shortID.toLowerCase() == 'm') {
      return 'Male';
    } else if (shortID.toLowerCase() == 'f') {
      return 'Female';
    }
    return 'Others';
  }

  Color getColor() {
    if (shortID.toLowerCase() == 'm') {
      return Colors.blue.shade300;
    } else if (shortID.toLowerCase() == 'f') {
      return Colors.pink.shade300;
    } else {
      return Colors.black;
    }
  }
}
