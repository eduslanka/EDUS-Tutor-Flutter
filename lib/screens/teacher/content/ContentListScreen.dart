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
import 'package:edus_tutor/utils/model/Content.dart';
import 'package:edus_tutor/utils/widget/Content_row.dart';

class ContentListScreen extends StatefulWidget {
  const ContentListScreen({super.key});

  @override
  _ContentListScreenState createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  // Future<ContentList> contents;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  String? _token;

  @override
  void initState() {
    super.initState();

    Utils.getStringValue('token').then((value) {
      setState(() {
        _token = value ?? '';
        // contents = fetchContent();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Content',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<ContentList>(
        future: fetchContent(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.contents.isNotEmpty) {
              return AnimatedList(
                key: _listKey,
                initialItemCount: snapshot.data?.contents.length ?? 0,
                itemBuilder: (context, index, animation) {
                  return ContentRow(
                    snapshot.data?.contents[index] ?? Content(),
                    animation,
                    onPressed: () async {
                      Utils.showToast(
                          '${snapshot.data?.contents[index].contentTitle} deleted');
                      _removeItem(index, snapshot.data?.contents ?? []);
                    },
                    token: _token ?? '',
                  );
                },
              );
            } else {
              return Utils.noDataWidget();
            }
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }

  void _removeItem(int index, List<Content> cList) {
    int removeIndex = index;
    Content removeItem = cList.removeAt(removeIndex);
    builder(context, animation) {
      return ContentRow(removeItem, animation, index: index);
    }

    _listKey.currentState?.removeItem(removeIndex, builder);
  }

  Future<ContentList> fetchContent() async {
    final response = await http.get(Uri.parse(EdusApi.getAllContent()),
        headers: Utils.setHeader(_token ?? ''));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      return ContentList.fromJson(jsonData['data']['uploadContents']);
    } else {
      throw Exception('failed to load');
    }
  }
}
