import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';

class MenuTileWidget extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final Color iconBackground;
  final Color titleColor;

  MenuTileWidget({
    required this.icon,
    required this.title,
    this.subtitle = "",
    required this.onTap,
    this.margin = const EdgeInsets.all(0),
    this.iconBackground = AppColor.primarySoft,
    this.titleColor = AppColor.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: AppColor.primarySoft, width: 1)),
        ),
        child: Row(
          children: [
            // Icon Box
            Container(
              width: 36,
              height: 36,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: icon,
            ),
            // Info
            Expanded(
              // ignore: unnecessary_null_comparison
              child: (subtitle == null)
                  ? Text('$title',
                      style: TextStyle(
                          color: titleColor,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$title',
                            style: const TextStyle(
                                color: AppColor.secondary,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('$subtitle',
                            style: TextStyle(
                                color: AppColor.secondary.withOpacity(0.7),
                                fontSize: 11)),
                      ],
                    ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppColor.border,
            ),
          ],
        ),
      ),
    );
  }
}
