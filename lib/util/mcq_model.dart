class McqModel {
  String question;
  List<String> options;
  int correctOptionIndex;

  McqModel(
      {required this.question,
      required this.options,
      required this.correctOptionIndex});
}
