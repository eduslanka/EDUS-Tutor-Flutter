class FeeType {
  int? id;
  String? name;
  dynamic description;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? feesGroupId;
  String? type;
  dynamic courseId;

  FeeType({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
    this.feesGroupId,
    this.type,
    this.courseId,
  });

  factory FeeType.fromJson(Map<String, dynamic> json) {
    return FeeType(
      id: json["id"],
      name: json["name"],
      description: json["description"]??"",
      createdBy: int.tryParse(json["created_by"])??0,
      updatedBy: int.tryParse(json["updated_by"])??0,
      schoolId: int.tryParse(json["school_id"])??0,
      academicId: int.tryParse(json["academic_id"])??0,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      feesGroupId: int.tryParse(json["fees_group_id"])??0,
      type: json["type"],
      courseId: json["course_id"],
    );
  }
}

class FeeTypeList {
  List<FeeType> feeTypes;

  FeeTypeList(this.feeTypes);

  factory FeeTypeList.fromJson(List<dynamic> json) {
    List<FeeType> feeTypeList = [];

    feeTypeList = json.map((i) => FeeType.fromJson(i)).toList();

    return FeeTypeList(feeTypeList);
  }
}
