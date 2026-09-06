import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.imageUrl,
    this.size = 44,
    this.online,
    this.borderColor,
  });

  final String imageUrl;
  final double size;
  final bool? online;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null,
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: AppColors.grey200),
              errorWidget: (context, url, error) => Container(
                color: AppColors.grey200,
                child: const Icon(Icons.person_rounded, color: AppColors.grey400),
              ),
            ),
          ),
        ),
        if (online != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: size * 0.28,
              width: size * 0.28,
              decoration: BoxDecoration(
                color: online! ? AppColors.success : AppColors.grey400,
                shape: BoxShape.circle,
                border: const Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
              ),
            ),
          ),
      ],
    );
  }
}
