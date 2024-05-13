// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:infixedu/utils/model/TeacherSubject.dart';

// ignore: must_be_immutable
class TeacherSubjectRowLayout extends StatelessWidget {

  TeacherSubject subject;


  TeacherSubjectRowLayout(this.subject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child:  Text(subject.subjectName ?? '',style:Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child:  Text(subject.subjectCode ?? '',style:Theme.of(context).textTheme.headlineMedium),
            ),
            Expanded(
              child:  Text(subject.subjectType == 'T' ? 'Theory' : 'Lab',style:Theme.of(context).textTheme.headlineMedium),
            ),
          ],
        ),
        Container(
          height: 0.5,
          margin: const EdgeInsets.only(top: 5.0,bottom: 5.0),
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
