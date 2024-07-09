class InvoiceNewDetail {
  int? id;
  String? feesType;
  int? amount;
  int? weaver;
  int? fine;
  int? subTotal;
  int? paidAmount;

  InvoiceNewDetail({
    this.id,
    this.feesType,
    this.amount,
    this.weaver,
    this.fine,
    this.subTotal,
    this.paidAmount,
  });

  factory InvoiceNewDetail.fromJson(Map<String, dynamic> json) {
    return InvoiceNewDetail(
      id: json['id'],
      feesType: json['fees_type'],
      amount: json['amount'],
      weaver: json['weaver'],
      fine: json['fine'],
      subTotal: json['sub_total'],
      paidAmount: json['paid_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fees_type': feesType,
      'amount': amount,
      'weaver': weaver,
      'fine': fine,
      'sub_total': subTotal,
      'paid_amount': paidAmount,
    };
  }
}

class FeesInvoice {
  int? id;
  String? invoiceId;
  int? totalFees;
  int? totalWeaver;
  int? totalPaid;
  int? totalDue;
  String? createDate;
  String? dueDate;
  List<InvoiceNewDetail>? invoiceDetails;

  FeesInvoice({
    this.id,
    this.invoiceId,
    this.totalFees,
    this.totalWeaver,
    this.totalPaid,
    this.totalDue,
    this.createDate,
    this.dueDate,
    this.invoiceDetails,
  });

  factory FeesInvoice.fromJson(Map<String, dynamic> json) {
    return FeesInvoice(
      id: json['id'],
      invoiceId: json['invoice_id'],
      totalFees: json['total_fees'],
      totalWeaver: json['total_weaver'],
      totalPaid: json['total_paid'],
      totalDue: json['total_due'],
      createDate: json['create_date'],
      dueDate: json['due_date'],
      invoiceDetails: json['invoice_details'] != null
          ? (json['invoice_details'] as List)
              .map((i) => InvoiceNewDetail.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'total_fees': totalFees,
      'total_weaver': totalWeaver,
      'total_paid': totalPaid,
      'total_due': totalDue,
      'create_date': createDate,
      'due_date': dueDate,
      'invoice_details': invoiceDetails?.map((i) => i.toJson()).toList(),
    };
  }
}

class ClassRecord {
  int? recordId;
  String? className;
  String? section;
  String? amount;
  List<FeesInvoice>? feesInvoice;

  ClassRecord({
    this.recordId,
    this.className,
    this.section,
    this.amount,
    this.feesInvoice,
  });

  factory ClassRecord.fromJson(Map<String, dynamic> json) {
    return ClassRecord(
      recordId: json['record_id'],
      className: json['class'],
      section: json['section'],
      amount: json['amount'],
      feesInvoice: json['feesInvoice'] != null
          ? (json['feesInvoice'] as List)
              .map((i) => FeesInvoice.fromJson(i))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'record_id': recordId,
      'class': className,
      'section': section,
      'amount': amount,
      'feesInvoice': feesInvoice?.map((i) => i.toJson()).toList(),
    };
  }
}
