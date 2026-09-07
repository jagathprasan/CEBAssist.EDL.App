import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 22,
    this.onTap,
  });

  final String name;
  final String? imageUrl;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.primaryContainer,
      foregroundColor: context.colors.onPrimaryContainer,
      backgroundImage: imageUrl == null ? null : NetworkImage(imageUrl!),
      child: imageUrl == null
          ? Text(
              name.initials,
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: radius * 0.72,
                color: context.colors.onPrimaryContainer,
              ),
            )
          : null,
    );

    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}
