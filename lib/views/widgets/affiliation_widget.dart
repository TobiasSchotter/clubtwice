import 'package:flutter/material.dart';
import '../../constant/app_color.dart';
import '../../core/model/Article.dart';

class RichTextBuilderAffiliation {
  static Column buildRichTextInfo2(Article article) {
    final style = TextStyle(
      color: AppColor.secondary.withOpacity(0.7),
      height: 1.5,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRichTextRow2("Verein", article.club, style, showDivider: true),
        buildRichTextRow2("Sportart", article.sport, style, showDivider: false),
      ],
    );
  }
}

Widget buildRichTextRow2(String label, String value, TextStyle style,
    {bool showDivider = true}) {
  if (value.isEmpty) {
    // Wert ist leer, also keine Zeile erstellen
    return Container();
  }

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 3), // Anpassung des Text-Offsets
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: style.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: style.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (showDivider)
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 3), // Anpassung des Divider-Offsets
          child: Container(
            height: 1,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
    ],
  );
}
