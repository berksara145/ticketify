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
      id: json['issue_id'].toString(), // Convert issue_id to String
      title: json['issue_name'] ?? '',
      details: json['issue_text'] ?? '',
      responses: json['responses'] != null
          ? List<String>.from(
              json['responses'].map((response) => response['response_text']))
          : [],
    );
  }

  bool get isSolved => responses.isNotEmpty;
}
