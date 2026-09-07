import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../models/user_profile.dart';

/// Currently signed-in employee, or the sample profile before login completes.
final currentUserProvider = Provider<UserProfile>((ref) {
  return ref.watch(authProvider).user ?? UserProfile.sample;
});
