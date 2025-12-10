import 'package:flutter/material.dart';

class SolveExamScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  const SolveExamScreen({super.key, required this.questions});

  @override
  State<SolveExamScreen> createState() => _SolveExamScreenState();
}

class _SolveExamScreenState extends State<SolveExamScreen> {
  int currentIndex = 0;
  Map<int, String> answers = {};

  void nextQuestion() {
    if (currentIndex < widget.questions.length - 1) {
      setState(() => currentIndex++);
    }
  }

  void prevQuestion() {
    if (currentIndex > 0) {
      setState(() => currentIndex--);
    }
  }

  void submit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(
          questions: widget.questions,
          answers: answers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var q = widget.questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Solve Exam")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Question ${currentIndex + 1}/${widget.questions.length}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            Text(q["question"], style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            ...["A", "B", "C", "D"].map((option) {
              return RadioListTile<String>(
                title: Text(q["options"][option]),
                value: option,
                groupValue: answers[currentIndex],
                onChanged: (value) {
                  setState(() {
                    answers[currentIndex] = value!;
                  });
                },
              );
            }),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: prevQuestion,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: nextQuestion,
                  child: const Text("Next"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: submit,
              child: const Text("Submit Exam"),
            ),
          ],
        ),
      ),
    );
  }
}

class ExamResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final Map<int, String> answers;

  const ExamResultScreen({
    super.key,
    required this.questions,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      if (answers[i] == questions[i]["correct"]) {
        score++;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Exam Result")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Score: $score / ${questions.length}",
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (_, index) {
                  var q = questions[index];
                  bool correct = answers[index] == q["correct"];

                  return Card(
                    child: ListTile(
                      title: Text("Q${index + 1}: ${q["question"]}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Answer: ${answers[index] ?? "Not answered"}"),
                          Text("Correct Answer: ${q["correct"]}"),
                        ],
                      ),
                      trailing: Icon(
                        correct ? Icons.check_circle : Icons.cancel,
                        color: correct ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
