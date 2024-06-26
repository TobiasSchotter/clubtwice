import 'package:flutter/material.dart';

import '../../constant/app_color.dart';

class UserProfileSection extends StatelessWidget {
  final String profileImageUrl;
  final String userName;
  final int articleCount;
  final bool isFetching;
  final VoidCallback onTap;

  const UserProfileSection({
    Key? key,
    required this.profileImageUrl,
    required this.userName,
    required this.articleCount,
    required this.isFetching,
    required this.onTap,
  }) : super(key: key);

@override
Widget build(BuildContext context) {
  String abbreviatedUserName = _abbreviateUserName(userName);
  
  return GestureDetector(
    onTap: articleCount > 0 ? onTap : null,
    child: Container(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: getImageProvider(profileImageUrl),
          ),
          const SizedBox(width: 8),
          Text(
            abbreviatedUserName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          articleCount > 0
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isFetching
                              ? const CircularProgressIndicator()
                              : Text(
                                  '$articleCount',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ),
                        ],
                      ),
                      const Text(
                        ' Artikel',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    ),
  );
}

String _abbreviateUserName(String userName) {
  const int maxLength = 16; // Max length of username before abbreviation
  if (userName.length <= maxLength) {
    return userName;
  } else {
    return userName.substring(0, maxLength - 3) + "...";
  }
}


  ImageProvider getImageProvider(String imageUrl) {
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage("assets/images/pp.png");
    }
  }
}
