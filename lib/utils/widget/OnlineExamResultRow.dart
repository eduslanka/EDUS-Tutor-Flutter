// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import 'package:infixedu/utils/model/ONlineExamResult.dart';

// ignore: must_be_immutable
class OnlineExamResultRow extends StatefulWidget {
  OnlineExamResult result;

  OnlineExamResultRow(this.result, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DormitoryScreenState createState() => _DormitoryScreenState(result);
}

class _DormitoryScreenState extends State<OnlineExamResultRow> {
  OnlineExamResult result;

  _DormitoryScreenState(this.result);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          result.subject ?? '',
          textAlign: TextAlign.start,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: ScreenUtil().setSp(15.0)),
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
                      'Full Marks',
                      textDirection: TextDirection.rtl,
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
                      result.marks.toString(),
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
                      'Pass Marks',
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
                      result.passMarks.toString(),
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
                      'Obtain',
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
                      result.obtains.toString(),
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
                      'Grade',
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
                      result.grade ?? '',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
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
                colors: [Colors.purple, Colors.deepPurple]),
          ),
        ),
      ],
    );
  }
}
