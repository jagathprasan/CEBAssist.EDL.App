import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../utils/media_url.dart';

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
    final resolved = resolveMediaUrl(imageUrl);
    final size = radius * 2;
    final avatar = ClipOval(
      child: Container(
        width: size,
        height: size,
        color: context.colors.primaryContainer,
        alignment: Alignment.center,
        child: resolved == null
            ? _Initials(name: name, radius: radius)
            : Image.network(
                resolved,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    _Initials(name: name, radius: radius),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _Initials(name: name, radius: radius);
                },
              ),
      ),
    );

    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name, required this.radius});

  final String name;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Text(
      name.initials,
      style: context.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: radius * 0.72,
        color: context.colors.onPrimaryContainer,
      ),
    );
  }
}
