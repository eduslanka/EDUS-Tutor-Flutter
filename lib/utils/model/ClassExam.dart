class ClassExamResult {
  String? examName;
  String? subject;
  dynamic marks;
  dynamic obtains;
  String? grade;

  ClassExamResult(
      {this.examName, this.subject, this.marks, this.obtains, this.grade});

  factory ClassExamResult.fromJson(Map<String, dynamic> json) {
    return ClassExamResult(
        examName: json['exam_name'],
        subject: json['subject_name'],
        marks: json['total_marks'],
        obtains: json['obtained_marks'],
        grade: json['grade']);
  }
}

class ClassExamResultList {
  List<ClassExamResult> results;
  String? position;
  String? grandTotal;
  String? grade;
  String? gpa;

  ClassExamResultList(
      this.results, this.position, this.grandTotal, this.grade, this.gpa);

  factory ClassExamResultList.fromJson(Map<String, dynamic> json) {
    List<ClassExamResult> resultList = [];

    String position = json["position"] ?? "";
    String grandTotal = json["grand_total"] ?? "";
    String grade = json["grade"] ?? "";
    String gpa = json["gpa"] ?? "";

    List<dynamic> result = json["exam_result"];
    resultList = result.map((i) => ClassExamResult.fromJson(i)).toList();
    return ClassExamResultList(resultList, position, grandTotal, grade, gpa);
  }
}
