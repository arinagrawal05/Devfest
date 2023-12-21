import 'package:devfest/reply_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget replywidget(ReplyData replyData) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(replyData.userImage),
          // child: Image.network(replyData.userImage),
          minRadius: 13,
          maxRadius: 14,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          replyData.name,
          style: GoogleFonts.inter(fontSize: 18),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
            height: 25, width: 25, child: Image.network(replyData.answerImage))
      ],
    ),
  );
}

// void scrollToBottom(ScrollController _scrollController) {
//   _scrollController.animateTo(
//     _scrollController.position.maxScrollExtent,
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.easeInOut,
//   );
// }
