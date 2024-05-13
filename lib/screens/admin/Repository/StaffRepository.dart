// Project imports:
import 'package:edus_tutor/screens/admin/ApiProvider/StaffApiProvider.dart';
import 'package:edus_tutor/utils/model/LeaveAdmin.dart';
import 'package:edus_tutor/utils/model/LibraryCategoryMember.dart';
import 'package:edus_tutor/utils/model/Staff.dart';

class StaffRepository {
  final StaffApiProvider _provider = StaffApiProvider();

  Future<LibraryMemberList> getStaff() {
    return _provider.getAllCategory();
  }

  Future<StaffList> getStaffList(int id) {
    return _provider.getAllStaff(id);
  }

  Future<LeaveAdminList> getStaffLeave(String url, String endPoint) {
    return _provider.getAllLeave(url, endPoint);
  }
}
