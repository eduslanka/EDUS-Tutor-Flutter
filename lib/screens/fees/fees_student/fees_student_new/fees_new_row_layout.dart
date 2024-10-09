// Flutter imports:
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/screens/fees/fees_student/fees_student_new/fees_add_payment_screen.dart';
import 'package:edus_tutor/screens/fees/fees_student/fees_student_new/fees_invoice_view.dart';

// Project imports:

import '../../../../model/fee_invoice_model.dart';

// ignore: must_be_immutable
class FeesRowNew extends StatefulWidget {
  FeesInvoice fee;

  FeesRowNew(this.fee, {super.key});

  @override
  State<FeesRowNew> createState() => _FeesRowNewState();
}

class _FeesRowNewState extends State<FeesRowNew> {
  final TextEditingController amountController = TextEditingController();
  late double blance;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    amountController.text = widget.fee.totalFees.toString();
    blance = (widget.fee.totalFees?.toDouble() ?? 0) -
        (widget.fee.totalPaid?.toDouble() ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.fee.dueDate.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
                maxLines: 1,
              ),
            ),
            PopupMenuButton(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Row(
                children: [
                  Text(
                    "Action".tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Icon(
                    Icons.arrow_downward,
                    size: 16,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                  ),
                ],
              ),
              itemBuilder: (context) {
                if (widget.fee.totalDue == 0) {
                  return [
                    PopupMenuItem(
                      value: 'view',
                      child: Text('View'.tr),
                    ),
                  ];
                } else {
                  return [
                    PopupMenuItem(
                      value: 'view',
                      child: Text('View'.tr),
                    ),
                    PopupMenuItem(
                      value: 'add-payment',
                      child: Text('Add Payment'.tr),
                    ),
                  ];
                }
              },
              onSelected: (String value) async {
                if (value == 'view') {
                  Get.to(() => FeeInvoiceViewStudent(
                        feesInvoice: widget.fee,
                      ));
                } else {
                  Get.to(() => FeesAddPaymentScreen(invoiceId: widget.fee.id));
                }
              },
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Amount',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      double.parse(widget.fee.totalFees.toString())
                          .toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Paid',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      double.parse(widget.fee.totalPaid.toString())
                          .toStringAsFixed(2),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Balance',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      blance.toStringAsFixed(2),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Status',
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    getStatus(context),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.5,
          margin: const EdgeInsets.only(top: 10.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xff053EFF), Color(0xff053EFF)]),
          ),
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2.5,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20.0, right: 20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                widget.fee.createDate.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Amount',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      widget.fee.totalFees.toString(),
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Discount',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    // Text(
                                    //   widget.fee.weaver == 0
                                    //       ? 'N/A'
                                    //       : widget.fee.weaver.toString(),
                                    //   maxLines: 1,
                                    //   style:
                                    //       Theme.of(context).textTheme.headlineMedium,
                                    // ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Fine',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    // Text(
                                    //   widget.fee.fine.toString(),
                                    //   maxLines: 1,
                                    //   style:
                                    //       Theme.of(context).textTheme.headlineMedium,
                                    // ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Paid',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      widget.fee.totalPaid.toString(),
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Balance',
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      blance.toString(),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Material(
                            color: Colors.white,
                            child: TextFormField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: false, signed: false),
                              style: Theme.of(context).textTheme.titleLarge,
                              controller: amountController,
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
                                if (int.tryParse(value)! > (blance ?? 0)) {
                                  return 'Amount must not greater than balance';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Amount",
                                labelText: "Amount",
                                labelStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                errorStyle: const TextStyle(
                                    color: Colors.blue, fontSize: 15.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        (blance ?? 0) > 0
                            ? GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {}
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Center(
                                        child: Text(
                                      'Continue',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16.0),
                                    )),
                                  ),
                                ),
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getStatus(BuildContext context) {
    if (blance == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.greenAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Paid',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if ((widget.fee.totalPaid == 0
            ? widget.fee.totalPaid
            : (double.parse(widget.fee.totalPaid.toString())))! >
        0.0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.amberAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'Partial',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else if (widget.fee.totalPaid == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.redAccent),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Text(
            'unpaid',
            textAlign: TextAlign.center,
            maxLines: 1,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
