import 'package:flutter/material.dart';

// Project imports:
import 'package:edus_tutor/screens/admin/Bloc/StaffListBloc.dart';
import 'package:edus_tutor/utils/CustomAppBarWidget.dart';
import 'package:edus_tutor/utils/apis/Apis.dart';
import 'package:edus_tutor/utils/model/Staff.dart';
import 'package:edus_tutor/utils/widget/Line.dart';
import 'package:edus_tutor/utils/widget/ScaleRoute.dart';
import 'AdminStaffDetails.dart';

// ignore: must_be_immutable
class StaffListScreen extends StatefulWidget {
  dynamic id;

  StaffListScreen(this.id, {super.key});

  @override
  _StaffListScreenState createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  StaffListBloc? listBloc;

  @override
  void initState() {
    super.initState();
    //blocStuff.getStaffList();
    listBloc = StaffListBloc(id: widget.id);
    listBloc?.getStaffList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: 'Staff List',
      ),
      body: StreamBuilder<StaffList>(
        stream: listBloc?.getStaffSubject.stream,
        builder: (context, snap) {
          if (snap.hasData) {
            if (snap.error != null) {
              return _buildErrorWidget(snap.error.toString());
            }
            return _buildStaffListWidget(snap.data ?? StaffList([]));
          } else if (snap.hasError) {
            return _buildErrorWidget(snap.error.toString());
          } else {
            return _buildLoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildStaffListWidget(StaffList data) {
    return ListView.builder(
      itemCount: data.staffs.length,
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    ScaleRoute(page: StaffDetailsScreen(data.staffs[index])));
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25.0,
                  backgroundImage: data.staffs[index].photo == null ||
                          data.staffs[index].photo == ""
                      ? NetworkImage(
                          "${EdusApi.root}public/uploads/staff/demo/staff.jpg")
                      : NetworkImage(
                          '${EdusApi.root}${data.staffs[index].photo}'),
                  backgroundColor: Colors.transparent,
                ),
                title: Text(
                  data.staffs[index].name ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Phone' ' : ${data.staffs[index].phone}',
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text('Address' ' : ${data.staffs[index].currentAddress}',
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
            const BottomLine(),
          ],
        );
      },
    );
  }
}
