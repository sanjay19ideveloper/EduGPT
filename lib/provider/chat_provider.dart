import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:gpt/model/chat_model.dart';
import 'package:gpt/service/api_service.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }
   void clearChatHistory() {
    chatList.clear();
    notifyListeners();
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  String toJsonString() {
    Map<String, dynamic> data = {
      'list': getChatList.map((e) => e.toJson()).toList()
    };
    String jsonString = jsonEncode(data);
    return jsonString;
  }

  static ChatProvider fromJson(Map<String, dynamic> json) {
    final List<dynamic> chatJson = json['list'];
    final List<ChatModel> chatList =
        chatJson.map((chat) => ChatModel.fromJson(chat)).toList();

    final chatProvider = ChatProvider();
    chatProvider.chatList = chatList;
    return chatProvider;
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await ApiService.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await ApiService.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
