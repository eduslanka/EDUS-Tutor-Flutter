// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;

// Project imports:
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/Utils.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/BookIssued.dart';
import 'package:edus_tutor/utils/widget/BookIssuedRow.dart';

// ignore: must_be_immutable
class BookIssuedScreen extends StatefulWidget {
  var id;

  BookIssuedScreen({super.key, this.id});

  @override
  _BookIssuedScreenState createState() => _BookIssuedScreenState();
}

class _BookIssuedScreenState extends State<BookIssuedScreen> {
  Future<BookIssuedList>? bookList;

  String? _token;

  @override
  void initState() {
    Utils.getStringValue('token').then((value) {
      _token = value ?? '';
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Utils.getStringValue('id').then((value) {
      setState(() {
        bookList = getIssuedBooks(
            widget.id != null ? int.parse(widget.id) : int.parse(value ?? ''));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Book Issued'),
      backgroundColor: Colors.white,
      body: FutureBuilder<BookIssuedList>(
        future: bookList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.bookIssues.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data?.bookIssues.length ?? 0,
                  itemBuilder: (context, index) {
                    return BookListRow(
                        snapshot.data?.bookIssues[index] ?? BookIssued());
                  },
                ),
              );
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
    );
  }

  Future<BookIssuedList> getIssuedBooks(dynamic id) async {
    final response = await http.get(Uri.parse(EdusApi.getStudentIssuedBook(id)),
        headers: Utils.setHeader(_token.toString()));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return BookIssuedList.fromJson(jsonData['data']['issueBooks']);
    } else {
      throw Exception('Failed to load');
    }
  }
}
