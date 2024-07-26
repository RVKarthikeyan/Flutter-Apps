// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'dart:convert';
import 'package:feedback_app/home_page.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _regNo = TextEditingController();

  final _dOB = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 238, 195),
              Color.fromARGB(255, 240, 80, 83),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Center(
                child: Container(
                  height: 350,
                  child: Card(
                    elevation: 18,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset("assets/login.png"),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: TextField(
                  controller: _regNo,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 228, 225),
                      border: OutlineInputBorder(),
                      hintText: 'Enter Registration Number',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(100, 0, 0, 0))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
                child: TextField(
                  controller: _dOB,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 228, 225),
                      border: OutlineInputBorder(),
                      hintText: 'Enter DOB(dd-mm-yyyy)',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(100, 0, 0, 0))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () => login(_regNo.text, _dOB.text, context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 255, 228, 225)),
                  elevation: MaterialStateProperty.all(0),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Color.fromARGB(255, 240, 80, 83)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> login(String regNo, String dob, context) async {
  const apiUrl = 'http://13.233.95.92:4000/api/student/studentID';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'regNo': regNo,
        'dob': dob,
      }),
    );

    print('HTTP Response Code: ${response.statusCode}');
    print('HTTP Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData is List && responseData.isNotEmpty) {
        print('Login successful: $responseData');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(regNo: regNo)),
        );
      } else if (responseData is String && responseData == 'Wrong password') {
        print('Login failed: Wrong password');
        // Show an error message to the user
      } else {
        print('Unexpected response format: $responseData');
      }
    } else {
      print('Failed to login: ${response.body}');

      // Show an error message to the user
    }
  } catch (error) {
    print('Error: $error');
    // Show an error message to the user
  }
}
