// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:edus_tutor/utils/CardItem.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/FunctinsData.dart';

// ignore: must_be_immutable
class DownloadsHome extends StatefulWidget {
  final _titles;
  final _images;
  var id;

  DownloadsHome(this._titles, this._images, {super.key, this.id});

  @override
  _DownloadsHomeState createState() =>
      _DownloadsHomeState(_titles, _images, sId: id);
}

class _DownloadsHomeState extends State<DownloadsHome> {
  bool? isTapped;
  int? currentSelectedIndex;
  final _titles;
  final _images;
  var sId;

  _DownloadsHomeState(this._titles, this._images, {this.sId});

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Study Materials'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                  AppFunction.getDownloadsDashboardPage(context, _titles[index],
                      id: sId);
                });
              },
              headline: _titles[index],
              icon: _images[index],
            );
          },
        ),
      ),
    );
  }
}
