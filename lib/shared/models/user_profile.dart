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
    this.landline = '',
    this.userType = '',
    this.lastActivity = '',
    this.divisionId = '',
    this.branchId = '',
    this.unitId = '',
    this.subUnitId = '',
    this.roles = const [],
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
  final String landline;
  final String userType;
  final String lastActivity;
  final String divisionId;
  final String branchId;
  final String unitId;
  final String subUnitId;
  final String status;
  final String? avatarUrl;
  final List<String> roles;

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? fullName : parts.first;
  }

  String get titleLine {
    if (designation.isNotEmpty) return designation;
    if (userType.isNotEmpty) return userType;
    return companyId ?? '';
  }

  String get organizationLine {
    final parts = [
      if (divisionId.isNotEmpty) divisionId,
      if (branchId.isNotEmpty) branchId,
      if (unitId.isNotEmpty) unitId,
      if (subUnitId.isNotEmpty) subUnitId,
    ];
    if (parts.isNotEmpty) return parts.join(' · ');
    return office;
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    String read(String camel, String pascal, [String fallback = '']) {
      final value = json[camel] ?? json[pascal];
      if (value == null) return fallback;
      return value.toString();
    }

    List<String> readRoles() {
      final value = json['roles'] ?? json['Roles'];
      if (value is List) {
        return value
            .map((item) => item.toString())
            .where((item) => item.isNotEmpty)
            .toList();
      }
      return const [];
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
      landline: read('landline', 'Landline'),
      userType: read('userType', 'UserType'),
      lastActivity: read('lastActivity', 'LastActivity'),
      divisionId: read('divisionId', 'DivisionId'),
      branchId: read('branchId', 'BranchId'),
      unitId: read('unitId', 'UnitId'),
      subUnitId: read('subUnitId', 'SubUnitId'),
      status: read('status', 'Status', 'Active'),
      avatarUrl: read('avatarUrl', 'AvatarUrl').ifEmpty(null),
      roles: readRoles(),
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
      'landline': landline,
      'userType': userType,
      'lastActivity': lastActivity,
      'divisionId': divisionId,
      'branchId': branchId,
      'unitId': unitId,
      'subUnitId': subUnitId,
      'status': status,
      'avatarUrl': avatarUrl,
      'roles': roles,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? landline,
    String? avatarUrl,
    List<String>? roles,
  }) {
    return UserProfile(
      id: id,
      username: username,
      companyId: companyId,
      fullName: fullName ?? this.fullName,
      employeeId: employeeId,
      designation: designation,
      office: office,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      landline: landline ?? this.landline,
      userType: userType,
      lastActivity: lastActivity,
      divisionId: divisionId,
      branchId: branchId,
      unitId: unitId,
      subUnitId: subUnitId,
      status: status,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roles: roles ?? this.roles,
    );
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
    landline: '',
    userType: 'Staff',
    lastActivity: '',
    divisionId: 'DD1',
    branchId: '',
    unitId: '',
    status: 'Active',
    roles: ['User'],
  );
}

extension on String {
  String? ifEmpty(String? fallback) => trim().isEmpty ? fallback : this;
}
