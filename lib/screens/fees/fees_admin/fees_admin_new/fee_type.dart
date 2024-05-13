import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/Utils.dart';
import 'package:infixedu/utils/apis/Apis.dart';
import 'package:infixedu/screens/fees/model/FeesGroup.dart';
import 'package:infixedu/screens/fees/model/FeesType.dart';
import 'package:http/http.dart' as http;

class FeesTypeScreen extends StatefulWidget {
  const FeesTypeScreen({Key? key}) : super(key: key);

  @override
  _FeesTypeScreenState createState() => _FeesTypeScreenState();
}

class _FeesTypeScreenState extends State<FeesTypeScreen> {
  Future<FeeTypeList>? fees;

  String _token = '';

  TextEditingController? titleController, descripController;

  int? selectedFeeGroup;

  @override
  void initState() {
    super.initState();
    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        fees = getFeesTypes();
        fees?.then((value) async {
          getFeesGroups().then((value) {
            setState(() {
              selectedFeeGroup = value.feeGroups.first.id;
            });
          });
        });
      });
    });
  }

  Future<FeeTypeList> getFeesTypes() async {
    final response = await http.get(Uri.parse(InfixApi.adminFeesTypeList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeTypeList.fromJson(jsonData['feesTypes']);
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<FeeGroupList> getFeesGroups() async {
    final response = await http.get(Uri.parse(InfixApi.adminFeeList),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return FeeGroupList.fromJson(jsonData['feesGroups']);
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Fees Type',
      ),
      body: FutureBuilder<FeeTypeList>(
        future: fees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: snapshot.data?.feeTypes.length ?? 0,
                itemBuilder: (context, index) {
                  FeeType feeType = snapshot.data?.feeTypes[index] ?? FeeType();

                  return ListTile(
                    title: Text(
                      feeType.name ?? 'NA',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                      "${feeType.description ?? 'NA'}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showUpdateDialog(feeType);
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.deepPurple,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            final response = await http.post(
                              Uri.parse(InfixApi.adminFeesTypeDelete),
                              headers: Utils.setHeader(_token),
                              body: jsonEncode({
                                'id': feeType.id,
                              }),
                            );
                            if (response.statusCode == 200) {
                              setState(() {
                                fees = getFeesTypes();
                              });
                              if (response.body.contains(
                                  'This Data Already Used In Fees Group Please Remove Those Data First')) {
                                Utils.showToast(
                                    'This Data Already Used In Fees Group Please Remove Those Data First');
                              } else {
                                Utils.showToast('Deleted successfully');
                              }
                               return Future.value(true);
                            } else {
                               return Future.value(false);
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getFeesGroups().then((value) {
            showAddDialog(value);
          });
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.deepPurpleAccent,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void showAddDialog(FeeGroupList feesGroupList) {
    titleController = TextEditingController();
    descripController = TextEditingController();

    Get.dialog(
      StatefulBuilder(builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 20.0, right: 10.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: titleController,
                              style: Theme.of(context).textTheme.headlineMedium,
                              decoration:
                                  const InputDecoration(hintText: 'Enter title here'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButton(
                              elevation: 0,
                              isExpanded: true,
                              items: feesGroupList.feeGroups.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item.id,
                                  child: Text(
                                    item.name.toString(),
                                    style:
                                        Theme.of(context).textTheme.headlineMedium,
                                  ),
                                );
                              }).toList(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontSize: 13.0),
                              onChanged: (value) {
                                state(() {
                                  selectedFeeGroup = value as int?;
                                });
                              },
                              value: selectedFeeGroup,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              controller: descripController,
                              style: Theme.of(context).textTheme.headlineMedium,
                              decoration: const InputDecoration(
                                  hintText: 'Enter discription here'),
                            ),
                            Expanded(child: Container()),
                            Container(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                ),
                                onPressed: () async {
                                  final response = await http.post(
                                    Uri.parse(InfixApi.adminFeesTypeStore),
                                    headers: Utils.setHeader(_token),
                                    body: jsonEncode({
                                      'name': titleController?.text,
                                      'description': descripController?.text,
                                      'fees_group': selectedFeeGroup,
                                    }),
                                  );
                                  if (response.statusCode == 200) {
                                    Utils.showToast('Added successfully');

                                    setState(() {
                                      fees = getFeesTypes();
                                    });
                                    Get.back();
                                     return Future.value(true);
                                  } else {
                                     return Future.value(false);
                                  }
                                },
                                child: Text("Add".tr),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black,
                            )),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void showUpdateDialog(FeeType feeType) {
    titleController = TextEditingController();
    descripController = TextEditingController();
    titleController?.text = feeType.name ?? '';
    descripController?.text = feeType.description;

    Get.dialog(
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 10.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: titleController,
                            style: Theme.of(context).textTheme.headlineMedium,
                            decoration:
                                const InputDecoration(hintText: 'Enter title here'),
                          ),
                          TextField(
                            controller: descripController,
                            style: Theme.of(context).textTheme.headlineMedium,
                            decoration: const InputDecoration(
                                hintText: 'Enter discription here'),
                          ),
                          Expanded(child: Container()),
                          Container(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                              ),
                              onPressed: () async {
                                final response = await http.post(
                                  Uri.parse(InfixApi.adminFeesTypeUpdate),
                                  headers: Utils.setHeader(_token),
                                  body: jsonEncode({
                                    'name': titleController?.text,
                                    'description': descripController?.text,
                                    'id': feeType.id,
                                    'fees_group': selectedFeeGroup
                                  }),
                                );
                                if (response.statusCode == 200) {
                                  Utils.showToast('Updated successfully');

                                  setState(() {
                                    fees = getFeesTypes();
                                  });
                                  Get.back();
                                   return Future.value(true);
                                } else {
                                   return Future.value(false);
                                }
                              },
                              child: Text("Update".tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
