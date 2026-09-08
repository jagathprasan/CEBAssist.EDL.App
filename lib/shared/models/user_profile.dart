/// Authenticated employee profile shown throughout the shell.
class UserProfile {
  const UserProfile({
    required this.fullName,
    required this.employeeId,
    required this.designation,
    required this.office,
    required this.email,
    required this.mobile,
    required this.status,
    this.id,
    this.username,
    this.companyId,
    this.avatarUrl,
  });

  final String? id;
  final String? username;
  final String? companyId;
  final String fullName;
  final String employeeId;
  final String designation;
  final String office;
  final String email;
  final String mobile;
  final String status;
  final String? avatarUrl;

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.first;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String read(String camel, String pascal, [String fallback = '']) {
      final value = json[camel] ?? json[pascal];
      if (value == null) return fallback;
      return value.toString();
    }

    return UserProfile(
      id: read('id', 'Id').ifEmpty(null),
      username: read('username', 'Username').ifEmpty(null),
      companyId: read('companyId', 'CompanyId').ifEmpty(null),
      fullName: read('fullName', 'FullName', 'CEBAssist user'),
      employeeId: read('employeeId', 'EmployeeId'),
      designation: read('designation', 'Designation'),
      office: read('office', 'Office'),
      email: read('email', 'Email'),
      mobile: read('mobile', 'Mobile'),
      status: read('status', 'Status', 'Active'),
      avatarUrl: read('avatarUrl', 'AvatarUrl').ifEmpty(null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'companyId': companyId,
      'fullName': fullName,
      'employeeId': employeeId,
      'designation': designation,
      'office': office,
      'email': email,
      'mobile': mobile,
      'status': status,
      'avatarUrl': avatarUrl,
    };
  }

  static const sample = UserProfile(
    id: 'sample',
    username: 'edl.user',
    companyId: 'EDL',
    fullName: 'Thihara Kumarasinghe',
    employeeId: '04207',
    designation: 'Project Engineer',
    office: 'EDL',
    email: 'thihara.kumarasinghe@edl.la',
    mobile: '+856 20 000 0000',
    status: 'Active',
  );
}

extension on String {
  String? ifEmpty(String? fallback) => trim().isEmpty ? fallback : this;
}
