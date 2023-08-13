import 'package:flutter/material.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Search.dart';

class SearchHistoryTile extends StatelessWidget {
  SearchHistoryTile(
      {required this.data, required this.onTap, required this.onDelete});

  final SearchHistory data;
  final VoidCallback onTap;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColor.primarySoft,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(data.title),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(
              Icons.close,
              color: Colors.grey,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
