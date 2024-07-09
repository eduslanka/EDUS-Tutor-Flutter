
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:edus_tutor/config/app_config.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';

import '../../../../model/fee_invoice_model.dart';

class FeeInvoiceViewStudent extends StatefulWidget {
  final FeesInvoice feesInvoice;
  const FeeInvoiceViewStudent({Key? key,required this.feesInvoice, }) : super(key: key);
  @override
  _FeeInvoiceViewStudentState createState() => _FeeInvoiceViewStudentState();
}

class _FeeInvoiceViewStudentState extends State<FeeInvoiceViewStudent> {
 

  

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: "Fees Invoice",
      ),
      backgroundColor: Colors.white,
      body: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        AppConfig.appLogoBlue,
                        width: Get.width * 0.2,
                        height: Get.width * 0.2,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Invoice'.tr +
                                ": ${widget.feesInvoice.invoiceId}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Create Date'.tr +
                                ": ${widget.feesInvoice.createDate}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Due Date'.tr +
                                ": ${widget.feesInvoice.dueDate??''}",
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: widget.feesInvoice.invoiceDetails?.length ?? 0,
                    itemBuilder: (context, index) {
                      InvoiceNewDetail? feeRecord =
                           widget.feesInvoice.invoiceDetails?[index];

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          feeRecord?.feesType ?? 'NA',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 14),
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Amount'.tr,
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
                                          feeRecord?.amount.toString() ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Waiver'.tr,
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
                                          feeRecord?.weaver.toString() ?? '',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Fine'.tr,
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
                                          feeRecord?.fine.toString() ?? '',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Paid'.tr,
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
                                          feeRecord?.subTotal.toString() ?? '',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Sub Total'.tr,
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
                                          feeRecord?.subTotal .toString() ?? '',
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
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(widget.feesInvoice.totalFees.toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                       
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Waiver'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(widget.feesInvoice.totalWeaver.toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Fine'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(getTotalFine().toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Paid'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(widget.feesInvoice.totalPaid.toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            double.parse(((getGrandTotalAmount() -
                                            widget.feesInvoice.totalWeaver) +
                                        getTotalFine())
                                    .toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                       const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Due Balance'.tr,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            double.parse(widget.feesInvoice.totalDue.toString())
                                .toStringAsFixed(2),
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  // feeInvoiceDetailsModel.banks!.isNotEmpty
                  //     ? Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Text(
                  //             "Bank",
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleMedium
                  //                 ?.copyWith(fontSize: 16),
                  //           ),
                  //           ListView.separated(
                  //             physics: const NeverScrollableScrollPhysics(),
                  //             shrinkWrap: true,
                  //             itemBuilder: (context, bankIndex) {
                  //               FeeBank? bank =
                  //                   feeInvoiceDetailsModel.banks?[bankIndex];
                  //               return ListTile(
                  //                 contentPadding: EdgeInsets.zero,
                  //                 title: Text(
                  //                   bank?.bankName.toString() ?? '',
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .titleMedium
                  //                       ?.copyWith(fontSize: 14),
                  //                 ),
                  //                 subtitle: Column(
                  //                   children: <Widget>[
                  //                     Padding(
                  //                       padding:
                  //                           const EdgeInsets.only(top: 10.0),
                  //                       child: Row(
                  //                         children: <Widget>[
                  //                           Expanded(
                  //                             flex: 2,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: <Widget>[
                  //                                 Text(
                  //                                   'Account Name'.tr,
                  //                                   maxLines: 1,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium
                  //                                       ?.copyWith(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                 ),
                  //                                 const SizedBox(
                  //                                   height: 10.0,
                  //                                 ),
                  //                                 Text(
                  //                                   bank?.accountName.toString() ?? '',
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Expanded(
                  //                             flex: 3,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: <Widget>[
                  //                                 Text(
                  //                                   'Account Number'.tr,
                  //                                   maxLines: 1,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium
                  //                                       ?.copyWith(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                 ),
                  //                                 const SizedBox(
                  //                                   height: 10.0,
                  //                                 ),
                  //                                 Text(
                  //                                   bank?.accountNumber
                  //                                       .toString() ?? '',
                  //                                   maxLines: 1,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Expanded(
                  //                             flex: 1,
                  //                             child: Column(
                  //                               crossAxisAlignment:
                  //                                   CrossAxisAlignment.start,
                  //                               children: <Widget>[
                  //                                 Text(
                  //                                   'Type'.tr,
                  //                                   maxLines: 1,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium
                  //                                       ?.copyWith(
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .w500),
                  //                                 ),
                  //                                 const SizedBox(
                  //                                   height: 10.0,
                  //                                 ),
                  //                                 Text(
                  //                                   bank?.accountType.toString() ?? '',
                  //                                   maxLines: 1,
                  //                                   style: Theme.of(context)
                  //                                       .textTheme
                  //                                       .headlineMedium,
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //             },
                  //             separatorBuilder: (context, bankIndex) {
                  //               return const Divider();
                  //             },
                  //             itemCount: feeInvoiceDetailsModel.banks?.length ?? 0,
                  //           ),
                  //         ],
                  //       )
                  //     : const SizedBox.shrink(),
                ],
              )
            
    );
  }

  getTotalFine() {
    double amount = 0.0;
    for (var element in widget.feesInvoice.invoiceDetails??[]) {
      amount += (element.fine ?? 0);
    }
    return amount;
  }

  // getTotalWeiver() {
  //   double amount = 0.0;
  //   for (var element in feeInvoiceDetailsModel.invoiceDetails!) {
  //     amount += (element.weaver ?? 0);
  //   }
  //   return amount;
  // }

  // getTotalPaidAmount() {
  //   double amount = 0.0;
  //   for (var element in feeInvoiceDetailsModel.invoiceDetails!) {
  //     amount += (element.subTotal ?? 0);
  //   }
  //   return amount;
  // }

  getGrandTotalAmount() {
    double amount = 0.0;

    for (var element in widget.feesInvoice.invoiceDetails!) {
      amount += (element.amount ?? 0);
    }
    return amount;
  }

  // getDueBalance() {
  //   double amount = 0.0;

  //   for (var element in feeInvoiceDetailsModel.invoiceDetails!) {
  //     amount += (element.total ?? 0);
  //   }
  //   return amount;
  // }
}
