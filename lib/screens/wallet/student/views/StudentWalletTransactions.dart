import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infixedu/screens/wallet/student/controller/student_wallet_controller.dart';
import 'package:infixedu/screens/wallet/student/model/Wallet.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/CustomBottomSheet.dart';
import 'package:infixedu/utils/CustomSnackBars.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:intl/intl.dart';

class StudentWalletTransactions extends StatefulWidget {
  const StudentWalletTransactions({Key? key}) : super(key: key);

  @override
  State<StudentWalletTransactions> createState() =>
      _StudentWalletTransactionsState();
}

class _StudentWalletTransactionsState extends State<StudentWalletTransactions> {
  final StudentWalletController _controller =
      Get.put(StudentWalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'My Wallet'),
      body: Obx(
        () {
          if (_controller.isWalletLoading.value) {
            return Container(
              alignment: Alignment.center,
              child: const CupertinoActivityIndicator(),
            );
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xff7C32FF),
                                Color(0xffC738D8),
                              ],
                            )),
                        child: Text("Balance: ".tr + '${_controller.wallet.value.currencySymbol??0}' + '${_controller.wallet.value.myBalance??0}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _controller.file = File("").obs;
                          _controller.amountController.clear();
                          _controller.paymentNoteController.clear();
                          _controller.selectedPaymentMethod =
                              "Select Payment Method".tr.obs;
                          getDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff7C32FF),
                                  Color(0xffC738D8),
                                ],
                              )),
                          child: Text(
                            "Add Balance".tr,
                            style:
                                Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text('Date'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Method'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Amount'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                              Expanded(
                                child: Text('Status'.tr,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                await _controller.getMyWallet();
                              },
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _controller
                                    .wallet.value.walletTransactions?.length ?? 0,
                                shrinkWrap: true,
                                itemBuilder: ((context, index) {
                                  WalletTransaction? walletTransaction =
                                      _controller.wallet.value
                                          .walletTransactions?[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                              DateFormat.yMMMd()
                                                  .format(DateTime.parse(
                                                      walletTransaction
                                                          ?.createdAt
                                                          .toString() ?? ''))
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        ),
                                        Expanded(
                                          child: Text(
                                              walletTransaction?.paymentMethod.toString() ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        ),
                                        Expanded(
                                          child: Text(
                                              walletTransaction?.amount?.toStringAsFixed(2) ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () {
                                                if (walletTransaction?.status ==
                                                    "reject") {
                                                  CustomSnackBar().snackBarWarning(
                                                      "${walletTransaction?.rejectNote}");
                                                }
                                              },
                                              child: getStatus(
                                                  walletTransaction?.status ?? '')),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  getStatus(String status) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == "approve"
              ? Colors.green
              : status == "reject"
                  ? Colors.amber
                  : Colors.red,
          borderRadius: BorderRadius.circular(5)),
      child: Text(
        status.capitalizeFirst.toString(),
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: status == "approve"
                  ? Colors.white
                  : status == "reject"
                      ? Colors.blueGrey
                      : Colors.white,
            ),
      ),
    );
  }

  getDialog() {
    Get.bottomSheet(
      CustomBottomSheet(
        title: "Add Balance",
        initialChildSize: 0.7,
        children: <Widget>[
          TextField(
            style: Theme.of(context).textTheme.headlineMedium,
            controller: _controller.amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^(?!\.)(\d+)?\.?\d{0,2}'))
            ],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: "Amount".tr,
              labelText: "Amount".tr,
              hintStyle: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return DropdownButton(
              elevation: 0,
              isExpanded: true,
              hint: Text(
                "Select Payment Method".tr,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              items: _controller.wallet.value.paymentMethods?.map((item) {
                return DropdownMenuItem<String>(
                  value: item.method,
                  child: Text(
                    item.method ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                );
              }).toList(),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontSize: 13.0),
              onChanged: (value) {
                _controller.selectedPaymentMethod.value = '$value';

                _controller.chequeBankOrOthers();
              },
              value: _controller.selectedPaymentMethod.value,
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            if (_controller.selectedPaymentMethod.value ==
                "Select Payment Method") {
              return const SizedBox.shrink();
            } else {
              if (_controller.isBank.value) {
                return DropdownButton(
                  elevation: 0,
                  isExpanded: true,
                  hint: Text(
                    "Select Bank".tr,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  items: _controller.wallet.value.bankAccounts?.map((item) {
                    return DropdownMenuItem<BankAccount>(
                      value: item,
                      child: Text(
                        "${item.bankName} (${item.accountNumber})",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    );
                  }).toList(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 13.0),
                  onChanged: (value) {
                    _controller.selectedBank.value = value as BankAccount;
                  },
                  value: _controller.selectedBank.value,
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          }),
          Obx(() {
            if (_controller.selectedPaymentMethod.value ==
                "Select Payment Method") {
              return const SizedBox.shrink();
            } else {
              if (_controller.isCheque.value || _controller.isBank.value) {
                return Column(
                  children: [
                    TextField(
                      style: Theme.of(context).textTheme.headlineMedium,
                      controller: _controller.paymentNoteController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Note".tr,
                        hintStyle: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _controller.pickDocument();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Obx(() {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _controller.file.value == null ||
                                            _controller.file.value.path == ""
                                        ? _controller.isBank.value == true
                                            ? 'Select Bank payment slip'.tr
                                            : 'Select Cheque payment slip'.tr
                                        : _controller.file.value.path
                                            .split('/')
                                            .last,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    maxLines: 2,
                                  ),
                                );
                              }),
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
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          }),
          Obx(() {
            return _controller.selectedPaymentMethod.value !=
                    "Select Payment Method"
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (_controller.isPaymentProcessing.value) {
                        return;
                      } else {
                        if (_controller.selectedPaymentMethod.value == "Bank" ||
                            _controller.selectedPaymentMethod.value ==
                                "Cheque") {
                          if (_controller.file.value == null) {
                            CustomSnackBar().snackBarWarning(
                              "Select a payment slip first".tr,
                            );
                          } else {
                            _controller.submitPayment(
                              file: _controller.file.value,
                            );
                          }
                        } else {
                          _controller.submitPayment(context: context);
                        }
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * .5,
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: Utils.gradientBtnDecoration,
                        child: !_controller.isPaymentProcessing.value
                            ? Text(
                                "Submit".tr,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: Colors.white),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          })
        ],
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      persistent: true,
    );
  }
}
