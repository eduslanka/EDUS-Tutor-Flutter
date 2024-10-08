// Flutter imports:

// Project imports:
import '../../src/core/khalti_request_model.dart';
import '../../src/data/khalti_service.dart';

class PaymentConfirmationRequestModel extends KhaltiRequestModel {
  PaymentConfirmationRequestModel({
    required this.confirmationCode,
    required this.token,
    required this.transactionPin,
  });

  final String confirmationCode;
  final String token;
  final String transactionPin;

  @override
  Map<String, Object> toMap() {
    return {
      'confirmation_code': confirmationCode,
      'public_key': KhaltiService.publicKey,
      'token': token,
      'transaction_pin': transactionPin,
    };
  }

  @override
  String toString() {
    return 'PaymentConfirmationRequestModel:\n${toJson(beautify: true)}';
  }
}

class PaymentConfirmationResponseModel {
  PaymentConfirmationResponseModel({
    required this.idx,
    required this.amount,
    required this.mobile,
    required this.productIdentity,
    required this.productName,
    required this.token,
    required this.additionalData,
  });

  final String idx;
  final int amount;
  final String mobile;
  final String productIdentity;
  final String productName;
  final String token;
  final Map<String, Object> additionalData;

  factory PaymentConfirmationResponseModel.fromMap(Map<String, dynamic> map) {
    return PaymentConfirmationResponseModel(
      idx: map['idx'],
      amount: map['amount'],
      mobile: map['mobile'],
      productIdentity: map['product_identity'],
      productName: map['product_name'],
      token: map['token'],
      additionalData: {
        for (final entry in map.entries)
          if (entry.key.startsWith('merchant_')) ...{
            entry.key.substring(9): entry.value,
          },
      },
    );
  }

  @override
  String toString() {
    return 'PaymentConfirmationResponseModel{idx: $idx, amount: $amount, mobile: $mobile, productIdentity: $productIdentity, productName: $productName, token: $token, additionalData: $additionalData}';
  }
}
