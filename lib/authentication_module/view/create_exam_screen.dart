import 'package:flutter/material.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final examNameController = TextEditingController();
  int totalQuestions = 10;

  List<Map<String, dynamic>> questions = [];

  @override
  void initState() {
    super.initState();
    _generateQuestions();
  }

  void _generateQuestions() {
    questions = List.generate(totalQuestions, (index) {
      return {
        "question": "",
        "options": {"A": "", "B": "", "C": "", "D": ""},
        "correct": "A",
      };
    });
    setState(() {});
  }

  void saveExam() {
    // TODO: SEND to API
    print("Exam Saved: ${examNameController.text}");
    print("Questions: $questions");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create MCQ Exam")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: examNameController,
            decoration: const InputDecoration(labelText: "Exam Name"),
          ),

          const SizedBox(height: 20),

          DropdownButtonFormField<int>(
            value: totalQuestions,
            items: [5, 10, 20, 30].map((q) {
              return DropdownMenuItem(value: q, child: Text("$q Questions"));
            }).toList(),
            onChanged: (value) {
              totalQuestions = value!;
              _generateQuestions();
            },
            decoration: const InputDecoration(labelText: "Total Questions"),
          ),

          const SizedBox(height: 20),

          ...questions.asMap().entries.map((entry) {
            int index = entry.key;
            var question = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      decoration:
                      InputDecoration(labelText: "Question ${index + 1}"),
                      onChanged: (value) => question["question"] = value,
                    ),
                    const SizedBox(height: 8),
                    ...question["options"].keys.map((option) {
                      return TextField(
                        decoration: InputDecoration(labelText: "Option $option"),
                        onChanged: (value) =>
                        question["options"][option] = value,
                      );
                    }),

                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      value: question["correct"],
                      items: ["A", "B", "C", "D"].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (value) {
                        question["correct"] = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            );
          }),

          ElevatedButton(
            onPressed: saveExam,
            child: const Text("Save Exam"),
          ),
        ],
      ),
    );
  }
}
