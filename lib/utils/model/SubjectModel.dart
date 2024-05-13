class SubjectModel {
  SubjectModel({
    this.name,
    this.id,
    this.subjectType,
  });

  String? name;
  int? id;
  String? subjectType;

  factory SubjectModel.fromJson(Map<String, dynamic> json) => SubjectModel(
        name: json["subject_name"],
        id: json["id"],
        subjectType: json["subject_type"],
      );
}

class SubjectModelList {
  List<SubjectModel> subjects = [];

  SubjectModelList(this.subjects);

  factory SubjectModelList.fromJson(List<dynamic> json) {
    List<SubjectModel> subjectList;

    subjectList = json.map((i) => SubjectModel.fromJson(i)).toList();

    return SubjectModelList(subjectList);
  }
}
