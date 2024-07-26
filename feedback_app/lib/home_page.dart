import 'package:feedback_app/slider_section.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.regNo});
  final String regNo;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<StudentData> studentData;
  late StudentData studentDetails;
  @override
  void initState() {
    super.initState();
    studentData = fetchStudentData(widget.regNo);
    studentData.then((data) {
      setState(() {
        studentDetails = data;
      });
    });
  }

  Future<StudentData> fetchStudentData(String regNo) async {
    final apiUrl = 'http://13.233.95.92:4000/api/student/$regNo';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final studentDetails = StudentData.fromJson(json.decode(response.body));
        print(
            'Fetched Student Data: ${studentDetails.stdName}, ${studentDetails.stdId}, ${studentDetails.courselist}');
        return studentDetails;
      } else {
        throw Exception('Failed to load student data');
      }
    } catch (error) {
      throw Exception('Failed to connect to the server');
    }
  }

  final Map<String, String> selectedValues = {};
  late String selectedCourse;
  final List<String> questions = [
    'Teacher comes to the class in time',
    'Teaching is well planned',
    'Aim/Objectives made clear',
    'Subject matter organised in logical sequence',
    'Teacher comes well prepared in the subject',
    'Teacher speaks clearly and audibly',
    'Teacher writes and draws legibly',
    'Teacher provides examples of concepts/principles.Explanations are clear and effective',
    'Teacher\'s pace and level of instruction are suited to the attainment of students',
    'Teacher offers assistance and counselling to the eed students',
    'Teacher asks questions to promote interaction and reflective thinking',
    'Teacher encourages questioning/raising doubts by students and answers them well',
    'Teaches and shares learner activity and problem solving everything in the class',
    'Teacher encourages, compliments and praises originally and creativity displayed by the student',
    'Teacher is courteous and impartial in dealing with the students',
    'Teacher engages classes regularly and maintains discipline',
    'Teacher covers the syllabus completely and at appropriate pace',
    'Teacher holds test regularly which are helpful to students in building up confidence in the acquisition and application of knowledge',
    'Teacher\'s marking of scripts is fair and impartial',
    'Teacher is prompt in valuing and returning the answer scripts providing feedback on performance',
  ];

  // Function to show the SliderSection modal
  Future<void> _showSliderModal(String course) async {
    selectedCourse = course;
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SliderSection(
              questions: questions,
              onSliderChanged: handleSliderChanged,
              onSubmit: _handleFormSubmit,
            ),
          ),
        );
      },
    );
  }

  // Function to handle slider changes
  void handleSliderChanged(String question, String value) {
    setState(() {
      selectedValues[question] = value;
    });
  }

  // Function to handle the submission
  void handleSubmit(Map<String, String> responses) {
    // Handle the submission logic here
    print(selectedCourse);
    print(selectedValues);
  }

  void _handleFormSubmit(Map<String, String> responses) {
    final apiUrl = 'http://13.233.95.92:4000/api/student/submit-form';

    // Convert responses map to a list of objects with qid, question, and response fields
    List<Map<String, dynamic>> formattedResponses = [];
    questions.asMap().forEach((index, question) {
      formattedResponses.add({
        'qid': (index + 1), // Keep qid as an integer
        'question': question,
        'response': responses[question] ??
            '', // Default to an empty string if response is null
      });
    });

    // Prepare the data to be sent to the server
    Map<String, dynamic> requestData = {
      'stdName': studentDetails.stdName,
      'regNo': studentDetails.stdId,
      'email': studentDetails.email,
      'phNo': studentDetails.phNo,
      'courseName': selectedCourse,
      'courseId': '',
      'sem': studentDetails.sem,
      'year': studentDetails.year,
      'responses': formattedResponses,
    };

    // Send the data to the server
    http
        .post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestData),
    )
        .then((response) {
      print(response);
      // Handle the response from the server
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Form submission successful: ${data['message']}');
        // Handle success, e.g., show a success message to the user
      } else {
        print('Form submission failed: ${response.body}');
        // Handle failure, e.g., show an error message to the user
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Feedback'),
        backgroundColor: const Color.fromARGB(255, 240, 80, 83),
      ),
      body: FutureBuilder<StudentData>(
        future: studentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final studentDetails = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Student Name',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(
                          width:
                              35), // Add some space between the Text and TextField
                      Expanded(
                        child: TextField(
                          readOnly: true,
                          controller: TextEditingController(
                              text: studentDetails.stdName),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Register Number',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentDetails.stdId)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Email',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(width: 110),
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentDetails.email)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Mobile Number',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentDetails.phNo)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Year',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 120,
                      ),
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentDetails.year)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Semester',
                        style: GoogleFonts.roboto(fontSize: 20),
                      ),
                      const SizedBox(
                        width: 70,
                      ),
                      Expanded(
                        child: TextField(
                            readOnly: true,
                            controller: TextEditingController(
                                text: studentDetails.sem)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButton<String>(
                    value: null,
                    hint: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Select Course",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    items: studentDetails.courselist.entries
                        .map((entry) => DropdownMenuItem<String>(
                              value: entry.key,
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _showSliderModal(value);
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class StudentData {
  final String id;
  final String stdName;
  final String stdId;
  final String email;
  final String phNo;
  final Map<String, String> courselist;
  final String sem;
  final String year;

  StudentData({
    required this.id,
    required this.stdName,
    required this.stdId,
    required this.email,
    required this.phNo,
    required this.courselist,
    required this.sem,
    required this.year,
  });

  factory StudentData.fromJson(Map<String, dynamic> json) {
    return StudentData(
      id: json['_id'],
      stdName: json['stdName'],
      stdId: json['stdId'],
      email: json['email'],
      phNo: json['phNo'],
      courselist: Map<String, String>.from(json['courselist']),
      sem: json['sem'],
      year: json['year'],
    );
  }
}
