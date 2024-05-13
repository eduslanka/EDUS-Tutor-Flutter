// To parse this JSON data, do
//
//     final feesDueReportModel = feesDueReportModelFromJson(jsonString);

import 'dart:convert';

FeesDueReportModel feesDueReportModelFromJson(String str) =>
    FeesDueReportModel.fromJson(json.decode(str));

String feesDueReportModelToJson(FeesDueReportModel data) =>
    json.encode(data.toJson());

class FeesDueReportModel {
  FeesDueReportModel({
    this.feesDues,
  });

  List<FeesDue>? feesDues;

  factory FeesDueReportModel.fromJson(Map<String, dynamic> json) =>
      FeesDueReportModel(
        feesDues: List<FeesDue>.from(json["feesDues"]
            .map((x) => x == null ? null : FeesDue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "feesDues": List<dynamic>.from(
            feesDues?.map((x) => x.toJson()) ?? []),
      };
}

class FeesDue {
  FeesDue({
    this.admissionNo,
    this.rollNo,
    this.name,
    this.dueDate,
    this.amount,
    this.paid,
    this.waiver,
    this.fine,
    this.balance,
  });

  String? admissionNo;
  String? rollNo;
  String? name;
  String? dueDate;
  num? amount;
  num? paid;
  num? waiver;
  num? fine;
  num? balance;

  factory FeesDue.fromJson(Map<String, dynamic> json) => FeesDue(
        admissionNo: json["admission_no"].toString(),
        rollNo: json["roll_no"].toString(),
        name: json["name"].toString(),
        dueDate: json["due_date"].toString(),
        amount: num.tryParse(json["amount"].toString()),
        paid: num.tryParse(json["paid"].toString()),
        waiver: num.tryParse(json["waiver"].toString()),
        fine: num.tryParse(json["fine"].toString()),
        balance: num.tryParse(json["balance"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "admission_no": admissionNo,
        "roll_no": rollNo,
        "name": name,
        "due_date": dueDate,
        "amount": amount,
        "paid": paid,
        "waiver": waiver,
        "fine": fine,
        "balance": balance,
      };
}
