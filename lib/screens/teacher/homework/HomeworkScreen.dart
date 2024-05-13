// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/CardItem.dart';
import 'package:infixedu/utils/CustomAppBarWidget.dart';
import 'package:infixedu/utils/FunctinsData.dart';

// ignore: must_be_immutable
class HomeworkHomeScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final _titles;
  // ignore: prefer_typing_uninitialized_variables
  final _images;

  const HomeworkHomeScreen(this._titles, this._images, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _HomeState createState() => _HomeState(_titles, _images);
}

class _HomeState extends State<HomeworkHomeScreen> {
  bool? isTapped;
  int? currentSelectedIndex;
  // ignore: prefer_typing_uninitialized_variables
  final _titles;
  // ignore: prefer_typing_uninitialized_variables
  final _images;

  _HomeState(this._titles, this._images);

  @override
  void initState() {
    super.initState();
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(title: 'Homework'),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
          itemCount: _titles.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return CustomWidget(
              index: index,
              isSelected: currentSelectedIndex == index,
              onSelect: () {
                setState(() {
                  currentSelectedIndex = index;
                  AppFunction.getHomeworkDashboardPage(context, _titles[index]);
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
