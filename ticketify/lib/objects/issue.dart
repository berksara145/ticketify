
class Issue {
  final String id;
  final String title;
  final String details;
  List<String> responses;

  Issue({
    required this.id,
    required this.title,
    required this.details,
    List<String>? responses,
  }) : responses = responses ?? [];

  factory Issue.fromJson(Map<String, dynamic> json) {
    return Issue(
      id: json['issue_id'],
      title: json['issue_name'] ?? '',
      details: json['issue_text'] ?? '',
      responses: List<String>.from(json['responses'] ?? []),
    );
  }

  bool get isSolved => responses.isNotEmpty;
}
