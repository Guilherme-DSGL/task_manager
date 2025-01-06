import 'package:flutter/material.dart';

import '../../themes/colors.dart';
import '../../themes/sizes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userPhoto;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: AppSizes.paddingHorizontal,
      title: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(
              Icons.check,
              color: AppColors.white1,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Taski',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                userName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(userPhoto),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
