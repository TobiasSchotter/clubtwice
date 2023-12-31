import 'package:flutter/material.dart';
import '../../constant/app_color.dart';

class DateWidget extends StatelessWidget {
  final DateTime dateTime;

  DateWidget({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            color: Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            "${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}",
            style: TextStyle(
              color: AppColor.secondary.withOpacity(0.7),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
