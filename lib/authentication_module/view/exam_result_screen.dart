import 'package:flutter/material.dart';

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
    int correct = 0;
    int wrong = 0;
    int skipped = 0;

    for (int i = 0; i < questions.length; i++) {
      if (!answers.containsKey(i)) {
        skipped++;
      } else if (answers[i] == questions[i]["correct"]) {
        correct++;
      } else {
        wrong++;
      }
    }

    int total = questions.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exam Result"),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// SCORE CARD
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    /// Score Circle
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.indigo,
                      child: Text(
                        "$correct/$total",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    /// Stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _resultStat("Correct", correct, Colors.green),
                        _resultStat("Wrong", wrong, Colors.red),
                        _resultStat("Skipped", skipped, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Detailed Analysis",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// RESULTS LIST
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (_, index) {
                  final question = questions[index];
                  final userAnswer = answers[index];
                  final correctAnswer = question["correct"];

                  final isCorrect = userAnswer == correctAnswer;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Question Text
                          Text(
                            "Q${index + 1}. ${question["question"]}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// User Answer
                          Text(
                            "Your Answer: ${userAnswer ?? "Not Answered"}",
                            style: TextStyle(
                              fontSize: 15,
                              color: isCorrect ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          /// Correct Answer
                          Text(
                            "Correct Answer: $correctAnswer",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// Options List
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: ["A", "B", "C", "D"].map((opt) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  "$opt. ${question["options"][opt]}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: opt == correctAnswer
                                        ? Colors.green
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable stat widget
  Widget _resultStat(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 6),
          Text("$title: $count", style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
