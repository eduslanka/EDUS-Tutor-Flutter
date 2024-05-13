import 'package:get/get.dart';

class Classes {
  String? name;
  int? id;

  Classes({this.name, this.id});

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      name: json['class_name'],
      id: int.parse(json['class_id'].toString()),
    );
  }
}

class ClassList {

  List<Classes> classes = [];

 // ClassList(this.classes);

   ClassList.fromJson(List<dynamic> json) {

    List<Classes> classList;
    classList = json.map((i) => Classes.fromJson(i)).toList();
    AllClasses.classes = classList;
    //return ClassList(classList);
  }
}
class AdminClasses {
  String? name;
  int? id;

  AdminClasses({this.name, this.id});

  factory AdminClasses.fromJson(Map<String, dynamic> json) {

      return AdminClasses(
        name: json['class_name'],
        id: int.parse(json['id'].toString()),
      );

  }
}

class AllClasses{

  static List<dynamic> classes = [];

}
class AdminClassList {

 // static List<AdminClasses> classes = [];

 // AdminClassList(this.classes);

   AdminClassList.fromJson(List<dynamic> json) {

    List<AdminClasses> classList;

    print("Data : ${json}");

    classList = json.map((i) => AdminClasses.fromJson(i)).toList();
    AllClasses.classes = classList;

    //return classList;
  }
}
