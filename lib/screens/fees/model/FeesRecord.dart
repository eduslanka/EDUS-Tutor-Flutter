class FeesRecord {
  int? id;
  num? amount;
  num? weaver;
  num? fine;
  num? paidAmount;
  num? subTotal;
  num? balance;
  String? student;
  String? recordClass;
  String? section;
  String? status;
  String? date;

  FeesRecord({
    this.id,
    this.amount,
    this.weaver,
    this.fine,
    this.paidAmount,
    this.subTotal,
    this.balance,
    this.student,
    this.recordClass,
    this.section,
    this.status,
    this.date,
  });

  factory FeesRecord.fromJson(Map<String, dynamic> json) {
    return FeesRecord(
      id: json["id"],
      amount: num.tryParse(json["amount"].toString())??0,
      weaver: num.tryParse(json["weaver"].toString()),
      fine: num.tryParse(json["fine"].toString())??0,
      paidAmount: num.tryParse(json["paid_amount"].toString())??0,
      subTotal: num.tryParse(json["sub_total"].toString())??0,
      balance: num.tryParse(json["balance"].toString())??0,
      student: json["student"],
      recordClass: json["class"],
      section: json["section"],
      status: json["status"],
      date: json["date"],
    );
  }
}

class FeesRecordList {
  List<FeesRecord>? feesRecords;

  FeesRecordList({this.feesRecords});

  factory FeesRecordList.fromJson(List<dynamic> json) {
    List<FeesRecord> feesRecordList = [];

    feesRecordList = json.map((i) => FeesRecord.fromJson(i)).toList();

    return FeesRecordList(feesRecords : feesRecordList);
  }
}
