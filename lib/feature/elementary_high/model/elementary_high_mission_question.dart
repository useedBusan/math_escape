// class ElementaryHighMissionQuestion {
//   final int id;
//   final String title;
//   final String question;
//   final List<String> answer;
//   final String hint1;
//   final String hint2;
//   final String? questionImage;
//
//   ElementaryHighMissionQuestion({
//     required this.id,
//     required this.title,
//     required this.question,
//     required this.answer,
//     required this.hint1,
//     required this.hint2,
//     this.questionImage,
//   });
//
//   factory ElementaryHighMissionQuestion.fromJson(Map<String, dynamic> json) {
//     return ElementaryHighMissionQuestion(
//       id: json['id'],
//       title: json['title'],
//       question: json['question'],
//       answer: List<String>.from(json['answer']),
//       hint1: json['hint1'] ?? '',
//       hint2: json['hint2'] ?? '',
//       questionImage: json['questionImage'],
//     );
//   }
// }