// Package imports:
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:edus_tutor/screens/admin/Repository/StaffRepository.dart';
import 'package:edus_tutor/utils/model/Staff.dart';

class StaffListBloc {
  dynamic id;

  StaffListBloc({this.id});

  final _repository = StaffRepository();

  final _subject = BehaviorSubject<StaffList>();

  getStaffList() async {
    StaffList list = await _repository.getStaffList(id);
    _subject.sink.add(list);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<StaffList> get getStaffSubject => _subject;
}
