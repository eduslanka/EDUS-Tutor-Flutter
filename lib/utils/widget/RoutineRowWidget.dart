// Flutter imports:
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RoutineRowDesign extends StatelessWidget {
  String time;
  String subject;
  String room;

  // ignore: use_key_in_widget_constructors
  RoutineRowDesign(
    this.time,
    this.subject,
    this.room,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child:
              Text(time ?? "", style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(subject ?? "",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(room ?? "N/A",
              style: Theme.of(context).textTheme.headlineMedium),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class RoutineRowDesignTeacher extends StatelessWidget {
  String time;
  String subject;
  String room;
  String? classRoutineClass;
  String? section;

  RoutineRowDesignTeacher(this.time, this.subject, this.room,
      {Key? key, this.classRoutineClass, this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(time ?? "",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Expanded(
            flex: 2,
            child: Text("$classRoutineClass ($section) - $subject",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          Expanded(
            flex: 1,
            child: Text(room ?? "",
                style: Theme.of(context).textTheme.headlineMedium),
          ),
        ],
      ),
    );
  }
}
