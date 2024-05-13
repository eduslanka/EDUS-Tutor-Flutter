// To parse this JSON data, do
//
//     final paymentMethod = paymentMethodFromJson(jsonString);

// Dart imports:
import 'dart:convert';


List<PaymentMethod> allPaymentMethodsFromJson(String str) =>
    List<PaymentMethod>.from(
            json.decode(str).map((x) => PaymentMethod.fromJson(x)))
        .where((element) {
      return element.activeStatus == 1 &&
          element.method != "Cash";
    }).toList();

class PaymentMethod {
  PaymentMethod({
    this.id,
    this.method,
    this.type,
    this.activeStatus,
    this.createdAt,
    this.gatewayId,
    this.createdBy,
    this.updatedBy,
    this.schoolId,
  });

  int? id;
  String? method;
  String? type;
  int? activeStatus;
  DateTime? createdAt;
  dynamic gatewayId;
  int? createdBy;
  int? updatedBy;
  int? schoolId;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json["id"],
        method: json["method"],
        type: json["type"],
        activeStatus: json["active_status"],
        createdAt: DateTime.parse(json["created_at"]),
        gatewayId: json["gateway_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        schoolId: json["school_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method": method,
        "type": type,
        "active_status": activeStatus,
        "created_at": createdAt?.toIso8601String(),
        "gateway_id": gatewayId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "school_id": schoolId,
      };
}
