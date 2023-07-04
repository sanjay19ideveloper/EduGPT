import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt/constant/constant.dart';
import 'package:gpt/provider/chat_provider.dart';
import 'package:gpt/provider/model_provider.dart';
import 'package:gpt/service/assests_manager.dart';
import 'package:gpt/service/service.dart';
import 'package:gpt/widgets/chat_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../model/chat_model.dart';
import '../widgets/text_widget.dart';
import 'package:path_provider/path_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController = ScrollController();
  _scrollToBottom() {
    _listScrollController
        .jumpTo(_listScrollController.position.maxScrollExtent);
  }

  ChatProvider? preChat;

  late FocusNode focusNode;
  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    // loadPrevChat();
    focusNode = FocusNode();
    super.initState();
  }

  void loadPrevChat() async {
    preChat = await getChatHistory();
    setState(() {});
    debugPrint("previous chat ${preChat?.chatList.length}");
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];
  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
      if (chatProvider.chatList.isEmpty && preChat?.chatList.isNotEmpty == true) {
        chatProvider = preChat!;
        debugPrint("previous chat $preChat");
     }
    debugPrint("previous chat ${preChat?.chatList.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.cyan,
        // backgroundColor: const Color(0xff7062e3),
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
        title: const Center(child: Padding(
          padding: EdgeInsets.only(left:25.0),
          child: const Text("EduGPT"),
        )),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                 saveChatHistory(chatProvider.toJsonString());
                },
                icon:Image.asset(AssetsManager.saveIcon,height:20)
              ),
              IconButton(
                onPressed: () async {
                  loadPrevChat();
                },
               icon:Image.asset(AssetsManager.historyIcon,height:20)
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // FlatButton(
            //   onPressed: () {
            //     // chatProvider.toJson();
            //     // Get the chat history as a string
            //     // String chatHistory = getChatHistoryAsString();

            //     // Save the chat history to a file
            //     saveChatHistory(chatProvider.toJsonString());
            //   },
            //   child: const Text('Export Chat History'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     // getChatHistory();
            //     loadPrevChat();
            //   },
            //   child: Text('history'),
            // ),
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      isGptResponse: false,
                      isFromChatHistory: true,
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,

                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scrollListToEND() async {
    await Future.delayed(const Duration(milliseconds: 700));
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 700), // Duration of the animation
      curve: Curves.ease, // Animation curve
    );
    // _listScrollController.jumpTo(_listScrollController.position.maxScrollExtent);

    print('scrolled list to end');
  }

  Future<void> saveChatHistory(String chatHistory) async {
    // Parse the modified JSON string into a JSON object
    debugPrint('chat history is $chatHistory');

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/chat_history.txt');

    await file.writeAsString(chatHistory);
  }

  Future<ChatProvider> getChatHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/chat_history.txt');

      // Read the file contents as a string
      final contents = await file.readAsString();
      print('content is $contents');
      Map<String, dynamic> json;
      json = jsonDecode(contents);
      // return ChatProvider();
      return ChatProvider.fromJson(json);
    } catch (e) {
      print('Failed to read file: $e');
      return ChatProvider();
    }
  }

// String getChatHistoryAsString() {
//   final chatProvider = Provider.of<ChatProvider>(context, listen: false);
//   return chatProvider.getChatList.map((chat) => chat.msg).join('\n');
// }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
        scrollListToEND();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      setState(() {});
      scrollListToEND();
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
