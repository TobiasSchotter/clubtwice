import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubtwice/core/model/Article.dart';
import 'package:clubtwice/core/services/MessageService.dart';
import 'package:clubtwice/core/services/articles_service.dart';
import 'package:clubtwice/views/screens/page_switcher.dart';
import 'package:clubtwice/views/screens/product_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:intl/intl.dart';

class MessageDetailPage extends StatefulWidget {
  final String senderId;
  final String articleId;
  final String receiverUsername;
  final String receiverId;
  final String articleTitle;
  final String articleImageUrl;
  final bool isDeleted;
  final bool isSold;

  const MessageDetailPage({
    Key? key,
    required this.receiverId,
    required this.receiverUsername,
    required this.senderId,
    required this.articleId,
    required this.articleTitle,
    required this.articleImageUrl,
    required this.isDeleted,
    required this.isSold,
  }) : super(key: key);

  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final MessageService messageService = MessageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final ArticleService articleService = ArticleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: _buildAppBarTitle(),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const PageSwitcher(selectedIndex: 3),
            ));
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: Colors.black,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColor.primarySoft,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messageService.getMessages(
                widget.articleId,
                _firebaseAuth.currentUser!.uid,
                widget.receiverId,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });
                return ListView(
                  controller: _scrollController,
                  children: snapshot.data!.docs
                      .map((document) => _buildMessageItem(document))
                      .toList(),
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return GestureDetector(
      onTap: _navigateToProductDetail,
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: AppColor.border,
              image: DecorationImage(
                image: widget.articleImageUrl.isNotEmpty
                    ? NetworkImage(widget.articleImageUrl)
                    : const AssetImage('assets/images/placeholder.jpg')
                        as ImageProvider<Object>,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            '${widget.receiverUsername} - ${_getShortenedArticleTitle()}',
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _navigateToProductDetail() async {
    Article currentArticle = await getArticleById(widget.articleId);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          ProductDetail(article: currentArticle, id: widget.articleId),
    ));
  }

  String _getShortenedArticleTitle() {
    return widget.articleTitle.length > 15
        ? '${widget.articleTitle.substring(0, 15)}...'
        : widget.articleTitle;
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    String isoTimestampString = data['timestamp'];
    DateTime timestamp = DateTime.parse(isoTimestampString);
    String formattedTimestamp = DateFormat('dd MMM HH:mm').format(timestamp);

    var alignment = data['senderId'] == _firebaseAuth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: data['senderId'] == _firebaseAuth.currentUser!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: data['senderId'] == _firebaseAuth.currentUser!.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            _chatBubble(
              message: data['message'],
              isMe: data['senderId'] == _firebaseAuth.currentUser!.uid,
            ),
            const SizedBox(height: 5),
            Text(formattedTimestamp),
          ],
        ),
      ),
    );
  }

// user input
  Widget _buildMessageInput() {
// Define a formatter to limit the number of paragraphs
    final paragraphLimitFormatter =
        ParagraphLimitingTextInputFormatter(15, 750);

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColor.border, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              inputFormatters: [paragraphLimitFormatter], // Apply the formatter
              onChanged: (text) {
                // // Adjust scroll position when text changes
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   scrollToBottom();
                // });
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColor.primary,
                  ),
                ),
                hintText: 'Gebe hier deine Nachricht ein ...',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColor.border, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, bottom: 3),
            width: 42,
            height: 42,
            child: ElevatedButton(
              onPressed: sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.transparent,
              ),
              child:
                  const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            ),
          )
        ],
      ),
    );
  }

  void scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void sendMessage() async {
    final String message = _messageController.text;
    if (message.isNotEmpty) {
      await messageService.sendMessage(
          widget.receiverId, message, widget.articleId);
      _messageController.clear();
      scrollToBottom();
    }
  }

  Future<Article> getArticleById(String articleId) async {
    final article = await articleService.fetchArticleById(articleId);
    return article;
  }

  Widget _chatBubble({required String message, required bool isMe}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}

class ParagraphLimitingTextInputFormatter extends TextInputFormatter {
  final int maxParagraphs;
  final int maxCharacters;

  ParagraphLimitingTextInputFormatter(this.maxParagraphs, this.maxCharacters);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
// Check if the new text exceeds the maximum allowed characters
    if (newValue.text.length > maxCharacters) {
// If so, truncate the text to contain only the allowed number of characters
      final truncatedText = newValue.text.substring(0, maxCharacters);
// Return the truncated text
      return TextEditingValue(
        text: truncatedText,
        selection: newValue.selection.copyWith(
          baseOffset: min(truncatedText.length, maxCharacters),
          extentOffset: min(truncatedText.length, maxCharacters),
        ),
      );
    }
// If the new text is within the character limit, split it by paragraph (line breaks)
    final paragraphs = newValue.text.split('\n');
// Check if the number of paragraphs exceeds the limit
    if (paragraphs.length > maxParagraphs) {
// If so, truncate the text to contain only the allowed number of paragraphs
      final truncatedText = paragraphs.sublist(0, maxParagraphs).join('\n');
// Return the truncated text
      return TextEditingValue(
        text: truncatedText,
        selection: newValue.selection.copyWith(
          baseOffset: min(truncatedText.length, maxCharacters),
          extentOffset: min(truncatedText.length, maxCharacters),
        ),
      );
    }
// If the text is within both character and paragraph limits, allow the edit
    return newValue;
  }
}
