import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gpt/provider/chat_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  void removeItem(int index) async {
    final file = files[index];
    await file.delete();
    setState(() {
      files.removeAt(index);
      len--;
    });
  }

  void archiveItem(int index) async {
    final file = files[index];

    final directory = await getApplicationDocumentsDirectory();
    final archivedDirectory = Directory('${directory.path}/Archived');

    if (!archivedDirectory.existsSync()) {
      archivedDirectory.createSync();
    }

    final newPath = '${archivedDirectory.path}/${file.path.split('/').last}';
    await file.rename(newPath);

    setState(() {
      files.removeAt(index);
      len--;
    });
  }

  void shareItem(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      Share.shareFiles([filePath], text: 'Sharing file');
    }
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
                        return const SizedBox();
                      if (builder.hasData) {
                        return Slidable(
                          actionPane: const SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                             
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
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(builder
                                            .data!.getChatList.first.msg),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pop(
                                                  context, files[i].path);
                                            },
                                            child: const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                size: 20))
                                      ],
                                    ),
                                    Text(builder.data!.getChatList[1].msg,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ])),
                          actions: <Widget>[
                            // IconSlideAction(
                            //   caption: 'Archive',
                            //   color: Colors.blue,
                            //   icon: Icons.archive,
                            //  onTap: () => archiveItem
                            // ),
                            IconSlideAction(
                              caption: 'Share',
                              color: Colors.indigo,
                              icon: Icons.share,
                              onTap: () => shareItem(files[i].path),
                            ),
                          ],
                          secondaryActions: <Widget>[
                            // IconSlideAction(
                            //   caption: 'More',
                            //   color: Colors.black45,
                            //   icon: Icons.more_horiz,
                            //   // onTap: () => _showSnackBar('More'),
                            // ),
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => removeItem(i),
                            ),
                          ],
                        );
                      }
                      return const SizedBox();
                    });
              }
            },
          ),
        ));
  }
}
