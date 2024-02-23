// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class QuizQuestion {
  final String question;
  final List<String> questionList;
  QuizQuestion({
    required this.question,
    required this.questionList,
  });

  QuizQuestion copyWith({
    String? question,
    List<String>? questionList,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      questionList: questionList ?? this.questionList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'questionList': questionList,
    };
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
        question: map['question'] as String,
        questionList: List<String>.from(
          (map['questionList'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory QuizQuestion.fromJson(String source) =>
      QuizQuestion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'QuizQuestion(question: $question, questionList: $questionList)';

  @override
  bool operator ==(covariant QuizQuestion other) {
    if (identical(this, other)) return true;

    return other.question == question &&
        listEquals(other.questionList, questionList);
  }

  @override
  int get hashCode => question.hashCode ^ questionList.hashCode;
}
