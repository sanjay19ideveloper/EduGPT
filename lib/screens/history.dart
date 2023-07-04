import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gpt/provider/chat_provider.dart';
import 'package:path_provider/path_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int len = 0;
  List<File> files = [];

  void setLen() async {
    final directory = await getApplicationDocumentsDirectory();
    // print('hello ${.first.path}');
    int t = 0;
    for (var file in directory.listSync()) {
      if (file.path.split('/').last.split('.').last.toLowerCase() == 'txt') {
        t++;
        files.add(File(file.path));
      }
    }
    setState(() {
      len = t;
    });
  }

  Future<ChatProvider> getHistory(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(filePath);

    // Read the file contents as a string
    final contents = await file.readAsString();

    // Decode the JSON contents
    final json = jsonDecode(contents);

    // Return the ChatProvider instance
    return ChatProvider.fromJson(json);
  }

  @override
  void initState() {
    super.initState();
    setLen();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 2,
            title: const Text('History')),
        body: Center(
          child: ListView.builder(
            itemCount: len,
            itemBuilder: (context, i) {
              {
                return FutureBuilder<ChatProvider>(
                  future: getHistory(files[i].path),
                  builder: (context, builder) {
                  if (builder.connectionState == ConnectionState.waiting)
                    return SizedBox();
                  if (builder.hasData) {
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, files[i].path);
                      },
                      child: Container(
                        //  color: Colors.grey[200],
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child:Column(
                          
                          crossAxisAlignment : CrossAxisAlignment.start,
                          children:[
                          Row(
                            children: [
                              Text(builder.data!.getChatList.first.msg),
                              
                            ],
                          ),
                          Text(builder.data!.getChatList[1].msg,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis
                          ),
                        ])
                      ),
                    );
                  }
                   return SizedBox();
                });
              }
            },
          ),
        ));
  }
}
