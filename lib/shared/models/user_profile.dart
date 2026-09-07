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
    this.avatarUrl,
  });

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

  static const sample = UserProfile(
    fullName: 'Thihara Kumarasinghe',
    employeeId: '04207',
    designation: 'Project Engineer',
    office: 'Area Office Kandy',
    email: 'thihara.kumarasinghe@electricity.lk',
    mobile: '+94 71 234 5678',
    status: 'Active',
  );
}
