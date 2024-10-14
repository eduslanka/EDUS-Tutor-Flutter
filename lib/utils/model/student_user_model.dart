class StudentModel {
  final bool success;
  final bool studentHaveDueFees;

  final User user;

  StudentModel({
    required this.success,
    required this.studentHaveDueFees,
    required this.user,
    // required this.userDetails,

    // required this.systemSettings,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      success: json['success'],
      studentHaveDueFees: json['data']['student_have_due_fees'],

      user: User.fromJson(json['data']['user']),

      //  userDetails: UserDetails.fromJson(json['data']['userDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': {
        'student_have_due_fees': studentHaveDueFees,

        'user': user.toJson(),

        //  'system_settings': systemSettings.toJson(),
      },
    };
  }
}

class User {
  final int id;
  final String fullName;
  final String username;
  final String phoneNumber;
  final String email;
  final int activeStatus;

  final bool blockedByMe;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.activeStatus,
    required this.blockedByMe,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      activeStatus: json['active_status'],
      blockedByMe: json['blocked_by_me'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'username': username,
      'phone_number': phoneNumber,
      'email': email,
      'active_status': activeStatus,
      'blocked_by_me': blockedByMe,
    };
  }
}

// Additional models for UserDetails and SystemSettings can be added similarly.
