import 'package:flutter/material.dart';

class SliderSection extends StatefulWidget {
  const SliderSection(
      {super.key,
      required this.questions,
      required this.onSliderChanged,
      required this.onSubmit});

  final List<String> questions;
  final Function(String, String) onSliderChanged;
  final Function(Map<String, String> responses) onSubmit;

  @override
  _SliderSectionState createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  final List<String> sliderOptions = [
    'Poor',
    'Satisfactory',
    'Fair',
    'Good',
    'Very Good',
    'Excellent'
  ];
  final Map<String, String> selectedValues = {};
  void _submitForm() {
    // Call the callback function with the selected values
    widget.onSubmit(selectedValues);
  }

  void handleSliderChanged(String question, String value) {
    setState(() {
      selectedValues[question] = value;
    });
    widget.onSliderChanged(question, value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (String question in widget.questions)
          Column(
            children: [
              Text(question),
              Slider(
                value: selectedValues[question] != null
                    ? sliderOptions.indexOf(selectedValues[question]!) + 1.0
                    : 3.0, // Default to 'Fair'
                min: 1.0,
                max: sliderOptions.length.toDouble(),
                divisions: sliderOptions.length - 1,
                label: selectedValues[question] ?? 'Fair',
                onChanged: (value) {
                  setState(() {
                    selectedValues[question] = sliderOptions[value.toInt() - 1];
                  });
                },
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {
            _submitForm();
            Navigator.pop(context); // Close the modal
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}

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
