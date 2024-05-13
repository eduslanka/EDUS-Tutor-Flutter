// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:infixedu/utils/model/Teacher.dart';

// ignore: must_be_immutable
class StudentTeacherRowLayout extends StatefulWidget {
  Teacher teacher;
  dynamic per;

  StudentTeacherRowLayout(this.teacher, this.per, {Key? key}) : super(key: key);

  @override
  _StudentTeacherRowLayoutState createState() =>
      _StudentTeacherRowLayoutState();
}

class _StudentTeacherRowLayoutState extends State<StudentTeacherRowLayout> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: 18,
                child: Image.asset(
                  'assets/images/teacher.png',
                  scale: 2.0,
                )),
            const SizedBox(
              width: 5,
            ),
            Text(widget.teacher.teacherName.toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () async {
                // ignore: deprecated_member_use
                await canLaunch('mailto:${widget.teacher.teacherEmail}')
                    // ignore: deprecated_member_use
                    ? await launch('mailto:${widget.teacher.teacherEmail}')
                    : throw 'Could not launch ${widget.teacher.teacherEmail}';
              },
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    const Icon(
                      Icons.mail_outline,
                      color: Colors.indigo,
                      size: 18,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.teacher.teacherEmail.toString(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            widget.teacher.teacherPhone == null ||
                    widget.teacher.teacherPhone == ''
                ? Container()
                : InkWell(
                    onTap: () async {
                      // ignore: deprecated_member_use
                      await canLaunch('tel:${widget.teacher.teacherPhone}')
                          // ignore: deprecated_member_use
                          ? await launch('tel:${widget.teacher.teacherPhone}')
                          : throw 'Could not launch ${widget.teacher.teacherPhone}';
                    },
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            color: Colors.indigo,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.teacher.teacherPhone ?? '',
                            style:
                                Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontSize: 14,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}
