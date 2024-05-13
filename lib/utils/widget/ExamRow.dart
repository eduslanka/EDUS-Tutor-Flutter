// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/model/ClassExamList.dart';
import '../FunctinsData.dart';

// ignore: must_be_immutable
class StudentExamRow extends StatelessWidget {

  Exam exam;


  StudentExamRow(this.exam, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Exam: ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                exam.examName ?? '',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Subject: ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                exam.subjectName ?? 'N/A',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Flexible(
             fit: FlexFit.loose,
             child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Room No',
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
                            exam.roomNo ?? 'N/A',
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
                          'Date',
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
                        exam.date ?? 'N/A',
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
                          'Start',
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
                        exam.startTime == null ? 'N/A': AppFunction.getAmPm(exam.startTime ?? ''),
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
                          'End',
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
                        exam.endTime == null ? 'N/A': AppFunction.getAmPm(exam.endTime ?? ''),
                          maxLines: 1,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
           ),
          // Container(
          //   height: 0.5,
          //   margin: EdgeInsets.only(top: 10.0),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.centerRight,
          //         end: Alignment.centerLeft,
          //         colors: [Colors.purple, Colors.deepPurple]),
          //   ),
          // ),
        ],
      ),
    );
  }
}
