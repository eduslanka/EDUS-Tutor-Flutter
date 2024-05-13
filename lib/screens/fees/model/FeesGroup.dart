class FeeGroup {
  int? id;
  String? name;
  dynamic description;
  int? createdBy;
  int? updatedBy;
  int? schoolId;
  int? academicId;
  DateTime? createdAt;
  DateTime? updatedAt;

  FeeGroup({
    this.id,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
    this.academicId,
    this.createdAt,
    this.updatedAt,
  });

  factory FeeGroup.fromJson(Map<String, dynamic> json) {
    return FeeGroup(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      createdBy: int.tryParse(json["created_by"].toString())??1,
      updatedBy: int.tryParse(json["updated_by"].toString())??1,
      schoolId: int.tryParse(json["school_id"].toString())??1,
      academicId: int.tryParse(json["academic_id"].toString())??1,
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class FeeGroupList {
  List<FeeGroup> feeGroups;

  FeeGroupList(this.feeGroups);

  factory FeeGroupList.fromJson(List<dynamic> json) {
    List<FeeGroup> feeGroupsList = [];

    feeGroupsList = json.map((i) => FeeGroup.fromJson(i)).toList();

    return FeeGroupList(feeGroupsList);
  }
}
