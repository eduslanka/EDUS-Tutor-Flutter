class ClassListResponse {
  final bool success;
  final ClassListData data;
  final String message;

  ClassListResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory ClassListResponse.fromJson(Map<String, dynamic> json) {
    return ClassListResponse(
      success: json['success'],
      data: ClassListData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class ClassListData {
  final List<ClassList> classLists;

  ClassListData({
    required this.classLists,
  });

  factory ClassListData.fromJson(Map<String, dynamic> json) {
    var list = json['class_lists'] as List;
    List<ClassList> classList = list.map((i) => ClassList.fromJson(i)).toList();
    return ClassListData(classLists: classList);
  }

  Map<String, dynamic> toJson() {
    return {
      'class_lists': classLists.map((classList) => classList.toJson()).toList(),
    };
  }
}

class ClassList {
  final int id;
  final int classId;
  final int sectionId;
  final ClassDetails classDetails;
  final SectionDetails sectionDetails;

  ClassList({
    required this.id,
    required this.classId,
    required this.sectionId,
    required this.classDetails,
    required this.sectionDetails,
  });

  factory ClassList.fromJson(Map<String, dynamic> json) {
    return ClassList(
      id: json['id'],
      classId: json['class_id'],
      sectionId: json['section_id'],
      classDetails: ClassDetails.fromJson(json['class']),
      sectionDetails: SectionDetails.fromJson(json['section']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'section_id': sectionId,
      'class': classDetails.toJson(),
      'section': sectionDetails.toJson(),
    };
  }
}

class ClassDetails {
  final int id;
  final String className;

  ClassDetails({
    required this.id,
    required this.className,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      id: json['id'],
      className: json['class_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_name': className,
    };
  }
}

class SectionDetails {
  final int id;
  final String sectionName;

  SectionDetails({
    required this.id,
    required this.sectionName,
  });

  factory SectionDetails.fromJson(Map<String, dynamic> json) {
    return SectionDetails(
      id: json['id'],
      sectionName: json['section_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_name': sectionName,
    };
  }
}
