import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mini_chatapp/components/chat_bubble.dart';
import 'package:mini_chatapp/components/my_textfield.dart';
import 'package:mini_chatapp/services/auth/auth_service.dart';
import 'package:mini_chatapp/services/chat/chat_services.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat & auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          // cause a delay so that the keyboard has time to show up
          // then the amount of remaining space will be calculated,
          // then scroll down
          Future.delayed(
            Duration(
              milliseconds: 500,
            ),
            () => scrollDown(),
          );
        }
      },
    );

    // wait a bit for listview to be built, then scroll to bottom
    Future.delayed(
      Duration(milliseconds: 500),
      () => scrollDown(),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
    _messageController.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  // send message
  void sendMessage() async {
    // if there is something inside the textfield
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMesage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),
          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUserID;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //  errors
        if (snapshot.hasError) {
          return const Text('Error');
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading..');
        }

        // return list view
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // is current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUserID;

    // align message to the right if sender is the current user,
    // otherwise left

    return Container(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ChatBubble(
        message: data['message'],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // text field should take up most of the space
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 25),
            padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
