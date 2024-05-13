// Dart imports:
import 'dart:convert';
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' as GETx;
import 'package:http/http.dart' as http;

// Project imports:
import 'package:infixedu/config/app_config.dart';
import 'package:infixedu/controller/user_controller.dart';
import 'package:infixedu/screens/fees/paymentGateway/RazorPay/razorpay_service.dart';
import 'package:infixedu/screens/fees/paymentGateway/paypal/paypal_payment.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/utils/exception/DioException.dart';
import 'package:infixedu/utils/model/Bank.dart';
import 'package:infixedu/screens/fees/model/Fee.dart';
import 'package:infixedu/utils/model/PaymentMethod.dart';
import 'package:infixedu/utils/model/UserDetails.dart';
import 'package:infixedu/utils/widget/ScaleRoute.dart';
import 'package:infixedu/screens/fees/widgets/fees_payment_row_widget.dart';
import 'khalti/KhaltiPaymentScreen.dart';
import 'xendit/XenditScreen.dart';

import 'package:infixedu/screens/fees/paymentGateway/stripe/stripe_payment.dart'
    as StripePage;
// import 'package:flutter_stripe/flutter_stripe.dart' as FlutterStripe;

class FeePaymentMain extends StatefulWidget {
  final FeeElement fee;
  final String id;
  final String amount;

  const FeePaymentMain(this.fee, this.id, this.amount, {Key? key}) : super(key: key);

  @override
  _FeePaymentMainState createState() => _FeePaymentMainState();
}

class _FeePaymentMainState extends State<FeePaymentMain> {
  String? _email;
  String? _token;
  String? _schoolId;
  bool? isResponse = false;
  String? _id;

  final plugin = PaystackPlugin();

  Future<PaymentMethod>? getPayment;

  UserDetails _userDetails = UserDetails();

  @override
  void initState() {
    Utils.getStringValue('email').then((value) {
      _email = value;
    });
    Utils.getStringValue('id').then((value) {
      _id = value;
    });
    getPayment = getPaymentMethods() as Future<PaymentMethod>?;
    fetchUserDetails(widget.id);
    plugin.initialize(publicKey: payStackPublicKey);
    super.initState();
  }

  // Future getUserDetails() async{
  //   await fetchUserDetails(widget.id);
  // }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    await Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    await Utils.getStringValue('schoolId').then((value) {
      _schoolId = value;
    });

    final response = await http.get(
        Uri.parse(InfixApi.paymentMethods(_schoolId)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return allPaymentMethodsFromJson(jsonEncode(jsonString['data']));
    } else {
      throw Exception('Failed to load from api');
    }
  }

  Future onPayment(PaymentMethod payment) async {
    if (payment.method == "Bank") {
      Navigator.push(
          context,
          ScaleRoute(
              page: BankOrCheque(widget.id, widget.fee, _email ?? '', 'Bank Payment',
                  widget.amount)));
    } else if (payment.method == "Cheque") {
      Navigator.push(
          context,
          ScaleRoute(
              page: BankOrCheque(widget.id, widget.fee, _email ?? '',
                  'Cheque Payment', widget.amount)));
    } else if (payment.method == "PayPal") {
      await paymentDataSave("PayPal").then((value) {
        Navigator.push(
            context,
            ScaleRoute(
              page: PaypalPayment(
                fee: widget.fee.feesName,
                amount: widget.amount,
                onFinish: (onFinish) async {
                  await paymentCallBack('PayPal',
                      reference: value, status: onFinish['status']);
                },
              ),
            ));
      });
    } else if (payment.method == "Paystack") {
      await paymentDataSave("Paystack").then((value) async {
        await payStackPayment(value.toString());
      });
    } else if (payment.method == "Stripe") {
      await paymentDataSave("PayPal").then((value) {
        Navigator.push(
            context,
            ScaleRoute(
                page: StripePage.StripePaymentScreen(
              id: widget.id,
              paidBy: _id ?? '',
              email: _email ?? '',
              method: 'Stripe Payment',
              amount: widget.amount,
              onFinish: (onFinish) async {
                await paymentCallBack('Stripe',
                    reference: value, status: onFinish['status']);
              },
            )));
      });
    } else if (payment.method == "Xendit") {
      Navigator.push(
          context,
          ScaleRoute(
              page: XenditScreen(
            id: widget.id,
            paidBy: _id ?? '',
            fee: widget.fee,
            email: _email ?? '',
            method: 'Xendit Payment',
            userDetails: _userDetails,
            amount: widget.amount,
          )));
    } else if (payment.method == "Khalti") {
      Navigator.push(
          context,
          ScaleRoute(
              page: KhaltiPaymentScreen(
            id: widget.id,
            paidBy: _id ?? '',
            fee: widget.fee,
            email: _email ?? '',
            method: 'Khalti Payment',
            userDetails: _userDetails,
            amount: widget.amount,
          )));
    } else if (payment.method == "RazorPay") {
      await paymentDataSave("RazorPay").then((value) async {
        await callRazorPayService();
      });
    }
  }

  Future callRazorPayService() async {
    await RazorpayServices().openRazorpay(
      razorpayKey: razorPayApiKey,
      contactNumber: "",
      emailId: "",
      amount: double.parse(widget.amount.toString()),
      userName: "",
      successListener: (PaymentResponse paymentResponse) {
        /// here manage code for success payment. ///
        if (paymentResponse.paymentStatus) {}
      },
      failureListener: (PaymentResponse paymentResponse) {
        /// here manage code for failure or error in payment. ///
        if (paymentResponse.paymentStatus) {}
      },
    );
  }

  Map<String, dynamic>? paymentIntentData;

  Future<dynamic> paymentDataSave(String method) async {
    Map data = {
      'student_id': widget.id,
      'fees_type_id': widget.fee.feesTypeId,
      'amount': widget.amount,
      'method': method,
      'school_id': _userDetails.schoolId,
    };
    final response = await http.post(
      Uri.parse(InfixApi.paymentDataSave),
      body: jsonEncode(data),
      headers: {
        "Accept": "application/json",
        "Authorization": _token.toString(),
      },
    );

    var jsonString = jsonDecode(response.body);

    return jsonString['payment_ref'];
  }

  Future payStackPayment(dynamic referenceId) async {
    final finalAmount = (int.parse(widget.amount) * 100).toInt();
    Charge charge = Charge()
      ..amount = finalAmount
      ..currency = 'ZAR'
      ..reference = referenceId.toString()
      ..email = _userDetails.email.toString();
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status == true) {
      await paymentCallBack('PayStack',
          reference: referenceId, status: response.status);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message),
      ));
    }
  }

  Future paymentCallBack(dynamic method,
      {dynamic reference, dynamic status}) async {
    final response = await http.post(
      Uri.parse(
          InfixApi.paymentSuccessCallback(status, reference, widget.amount)),
      headers: {
        "Accept": "application/json",
        "Authorization": _token.toString(),
      },
    );
    await studentPayment(method);
  }

  // String _getReference() {
  //   return '${AppConfig.appName}_${DateTime.now().millisecondsSinceEpoch}';
  // }

  Future studentPayment(method) async {
    try {
      setState(() {
        isResponse = true;
      });

      final response = await http.get(
          Uri.parse(InfixApi.studentFeePayment(
              widget.id.toString(),
              int.parse(widget.fee.feesTypeId.toString()),
              widget.amount,
              _id ?? '',
              '$method')),
          headers: {
            "Accept": "application/json",
            "Authorization": _token.toString(),
          });
      if (response.statusCode == 200) {
        setState(() {
          isResponse = false;
        });
        var data = json.decode(response.body.toString());


        if (data['success'] == true) {
          Utils.showToast('Payment Added');
          Navigator.of(context).pop();
        } else {
          Utils.showToast('Some error occurred');
        }
      } else {
        setState(() {
          isResponse = true;
        });
      }
    } catch (e) {
      Exception(e.toString());
    }
  }

  Future<UserDetails> fetchUserDetails(id) async {
    await Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    final response = await http.get(Uri.parse(InfixApi.getChildren(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      _userDetails = UserDetails.fromJson(jsonData['data']['userDetails']);
      return _userDetails;
    } else {
      throw Exception('Failed to load from api');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Select Payment Method',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<PaymentMethod>>(
          future: getPayment as Future<List<PaymentMethod>>,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
                // if we got our data
              } else if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      PaymentMethod? payment = snapshot.data?[index];
                      return GestureDetector(
                        onTap: () {
                          onPayment(payment ?? PaymentMethod());
                        },
                        child: Card(
                          elevation: 4.0,
                          child: ListTile(
                            // contentPadding: EdgeInsets.all(15),
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.white,
                              child: SizedBox(
                                width: ScreenUtil().setWidth(25),
                                child: Image.asset(
                                  'assets/images/fees_icon.png',
                                ),
                              ),
                            ),
                            title: Text(
                              payment?.method.toString() ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      );
                    });
              }
            }
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }),
    );
  }
}

// ignore: must_be_immutable
class BankOrCheque extends StatefulWidget {
  final FeeElement fee;
  String email;
  final String id;
  final String paymentType;
  final String amount;

  BankOrCheque(this.id, this.fee, this.email, this.paymentType, this.amount, {Key? key}) : super(key: key);

  @override
  _BankOrChequeState createState() => _BankOrChequeState();
}

class _BankOrChequeState extends State<BankOrCheque> {
  final UserController _userController = GETx.Get.put(UserController());
  TextEditingController amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _file;
  bool isResponse = false;
  String? _token;
  Future<BankList>? bank;
  String? _selectedBank;
  String? bankAccountName;
  String? bankAccountNumber;
  int? bankId;
  bool bankAvailable = true;
  DateTime? _dateTime;
  var paymentDate;
  var paymentUrl;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        bank = getBankList();
        bank?.then((value) {
          _selectedBank =
              value.banks.length != 0 ? value.banks[0].bankName : '';
          bankId = value.banks.length != 0 ? value.banks[0].id : 0;
          bankAccountName =
              value.banks.length != 0 ? value.banks[0].accountName : '';
          bankAccountNumber =
              value.banks.length != 0 ? value.banks[0].accountNumber : '';
          if (widget.paymentType == "Bank Payment") {
            if (value.banks.length == 0) {
              bankAvailable = false;
            }
          } else {
            bankAvailable = true;
          }
        });
      });
    });
    amountController.text = widget.amount;

    _dateTime = DateTime.now();
    paymentDate =
        '${_dateTime?.year}-${getAbsoluteDate(_dateTime?.month ?? 0)}-${getAbsoluteDate(_dateTime?.day ?? 0)}';

    super.initState();
  }

  Future pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _file = File(result.files.single.path ?? '');
      });
    } else {
      Utils.showToast('Cancelled');
    }
  }

  Future<BankList> getBankList() async {
    final response = await http.get(Uri.parse(InfixApi.bankList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return BankList.fromJson(jsonData['data']['banks']);
    } else {
      throw Exception('Failed to load from api');
    }
  }

  int? getCode<T>(List<Banks> t, String title) {
    int? code;
    for (var cls in t) {
      if (cls.bankName == title) {
        code = cls.id;
        break;
      }
    }
    return code;
  }

  String? getBankAccountName<T>(List<Banks> t, String title) {
    String? code;
    for (var cls in t) {
      if (cls.bankName == title) {
        code = cls.accountName ?? '';
        break;
      }
    }
    return code;
  }

  String? getBankAccountNumber<T>(List<Banks> t, String title) {
    String? code;
    for (var cls in t) {
      if (cls.bankName == title) {
        code = cls.accountNumber ?? '';
        break;
      }
    }
    return code;
  }

  Future submitPayment(context, user) async {
    if (_formKey.currentState!.validate()) {
      if (_file != null) {
        if (widget.paymentType == "Bank Payment") {
          paymentUrl = InfixApi.childFeeBankPayment(
              amountController.text,
              _userController.selectedRecord.value.classId,
              _userController.selectedRecord.value.sectionId,
              widget.id,
              int.parse(widget.fee.feesTypeId.toString()),
              'bank',
              paymentDate,
              bankId);
        } else {
          paymentUrl = InfixApi.childFeeChequePayment(
            amountController.text,
            _userController.selectedRecord.value.classId,
            _userController.selectedRecord.value.sectionId,
            widget.id,
            int.parse(widget.fee.feesTypeId.toString()),
            'cheque',
            paymentDate,
          );
        }

        setState(() {
          isResponse = true;
        });
        FormData formData;
        if (widget.paymentType == "Bank Payment") {
          formData = FormData.fromMap({
            "amount": amountController.text,
            "class_id": _userController.selectedRecord.value.classId,
            "section_id": _userController.selectedRecord.value.sectionId,
            "student_id": widget.id,
            "fees_type_id": widget.fee.feesTypeId,
            "payment_mode": 'bank',
            "date": paymentDate,
            "bank_id": bankId,
            "slip": await MultipartFile.fromFile(_file?.path ?? ''),
          });
        } else {
          formData = FormData.fromMap({
            "amount": amountController.text,
            "class_id": _userController.selectedRecord.value.classId,
            "section_id": _userController.selectedRecord.value.sectionId,
            "student_id": widget.id,
            "fees_type_id": widget.fee.feesTypeId,
            "payment_mode": 'cheque',
            "date": paymentDate,
            "bank_id": bankId,
            "slip": await MultipartFile.fromFile(_file?.path ?? ''),
          });
        }
        Response response;
        var dio = Dio();

        response = await dio.post(
          paymentUrl,
          data: formData,
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": _token.toString(),
            },
          ),
          onSendProgress: (received, total) {
            if (total != -1) {
            }
          },
        ).catchError((e) {
          final errorMessage = DioExceptions.fromDioError(e).toString();
          Utils.showToast(errorMessage);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
        if (response.statusCode == 200) {
          setState(() {
            isResponse = false;
          });
          var data = json.decode(response.toString());


          if (data['success'] == true) {
            Utils.showToast('Payment added. Please wait for approval');
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          } else {
            Utils.showToast('Some error occurred');
          }
        } else {
          setState(() {
            isResponse = true;
          });
        }
      } else {
        Utils.showToast('Please select file');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: widget.paymentType,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: FutureBuilder<UserDetails>(
            future: fetchUserDetails(widget.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: FeePaymentRow(widget.fee),
                      ),
                      // Utils.checkTextValue("CLASS",user.classId),
                      widget.paymentType == "Bank Payment"
                          ? FutureBuilder<BankList>(
                              future: bank,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Column(
                                      children: [
                                        DropdownButton(
                                          elevation: 0,
                                          isExpanded: true,
                                          items:
                                              snapshot.data?.banks.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item.bankName,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0),
                                                child: Text(item?.bankName.toString() ?? ''),
                                              ),
                                            );
                                          }).toList(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(fontSize: 15.0),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedBank = value as String?;
                                              bankId = getCode(
                                                  snapshot.data!.banks, value ?? '');
                                              bankAccountName =
                                                  getBankAccountName(
                                                      snapshot.data!.banks,
                                                      value ?? '');
                                              bankAccountNumber =
                                                  getBankAccountNumber(
                                                      snapshot.data!.banks,
                                                      value ?? '');
                                              debugPrint(
                                                  'User select $bankId');
                                            });
                                          },
                                          value: _selectedBank,
                                        ),
                                        ListTile(
                                          contentPadding:
                                              const EdgeInsets.only(left: 8),
                                          title: Text(
                                            bankAccountName.toString() ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(fontSize: 14),
                                          ),
                                          subtitle: Text(
                                            bankAccountNumber.toString() ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              })
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false, signed: false),
                          style: Theme.of(context).textTheme.titleLarge,
                          controller: amountController,
                          enabled: false,
                          autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                          validator: (String? value) {
                            RegExp regExp = RegExp(r'^[0-9]*$');
                            if (value!.isEmpty) {
                              return 'Please enter a valid amount';
                            }
                            if (int.tryParse(value) == 0) {
                              return 'Amount must be greater than 0';
                            }
                            if (!regExp.hasMatch(value)) {
                              return 'Please enter a number';
                            }
                            if ((int.tryParse(value) ?? 0) > (int.tryParse(widget.fee.balance.toString()) ?? 0)) {
                              return 'Amount must not greater than balance';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Amount",
                            labelText: "Amount",
                            labelStyle: Theme.of(context).textTheme.headlineMedium,
                            errorStyle: const TextStyle(
                                color: Colors.pinkAccent, fontSize: 15.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          pickDocument();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.3)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      _file == null
                                          ? widget.paymentType ==
                                                  "Bank Payment"
                                              ? 'Select Bank payment slip'
                                              : 'Select Cheque payment slip'
                                          : _file?.path.split('/').last ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Browse',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      bankAvailable
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  height: 50.0,
                                  decoration: Utils.gradientBtnDecoration,
                                  child: Text(
                                    "PAY",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  submitPayment(context, user);
                                },
                              ),
                            )
                          : Text(
                            "No Bank Available for payment. Please use a different payment method.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isResponse == true
                            ? const LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                              )
                            : const Text(''),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            }),
      ),
    );
  }

  Future<UserDetails> fetchUserDetails(id) async {
    final response = await http.get(Uri.parse(InfixApi.getChildren(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return UserDetails.fromJson(jsonData['data']['userDetails']);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load from api');
    }
  }

  int absoluteAmount(String am) {
    int amount = int.parse(am);
    if (amount < 0) {
      return -amount;
    } else {
      return amount;
    }
  }

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }
}
