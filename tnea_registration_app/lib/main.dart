import 'package:flutter/material.dart';
import 'package:tnea_registration_app/pages/gender_wise_page.dart';
import 'package:tnea_registration_app/pages/summary_page.dart';
import 'package:tnea_registration_app/themes/light_mode.dart';

import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: lightMode,
        routes: {
          '/summary_page.dart': (context) => const SummaryPage(),
          '/gender_wise_page': (context) => const GenderWisePage(),
        });
  }
}
