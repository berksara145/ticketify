class Issue {
  final String title;
  final String details;
  List<String> responses;

  Issue({
    required this.title,
    required this.details,
    List<String>? responses,
  }) : responses = responses ?? [];

  bool get isSolved => responses.isNotEmpty;
}
