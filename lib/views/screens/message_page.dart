import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clubtwice/constant/app_color.dart';
import 'package:clubtwice/core/model/Message.dart';
import 'package:clubtwice/core/services/MessageService.dart';
import 'package:clubtwice/views/widgets/message_tile_widget.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Message> listMessage = MessageService.messageData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            const Text('Message',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
            Text('1 Unreaded',
                style: TextStyle(
                    fontSize: 10, color: Colors.black.withOpacity(0.7))),
          ],
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
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: List.generate(listMessage.length, (index) {
          return MessageTileWidget(
            data: listMessage[index],
          );
        }),
      ),
    );
  }
}
