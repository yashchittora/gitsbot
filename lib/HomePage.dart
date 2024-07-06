import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';

import 'Messages.dart';
import 'dart:developer';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState(){
    // DialogAuthCredentials credentials = await DialogAuthCredentials.fromFile('../assets/dialog_flow_auth.json');
    // await DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    initializer();
    super.initState();

  }

  initializer()async{
    log('Initializer called');
    // dialogFlowtter = await DialogFlowtter.fromFile();
    await DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    log(dialogFlowtter.credentials.toString());

    log('Initializer ended');

  }

  // void initState() {
  //   super.initState();
  //   initializeDialogFlowtter();
  // }
  //
  // void initializeDialogFlowtter() async {
  //   dialogFlowtter = await DialogFlowtter.fromFile();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text("GITS Bot",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.deepPurple.shade300,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              // color: Colors.deepPurple,
              child: Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0), // Add margin around the text field
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                              border: InputBorder.none,
                              hintText: 'Ask me anything about GITS',
                            ),
                          ),
                        ),
                      ),
                  ),
                  IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.deepPurple,
                        size: 30,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // sendMessage(String text) async {
  //   if (text.isEmpty) {
  //     log("Empty Message");
  //   } else {
  //     setState(() {
  //       log("User message set state");
  //       addMessage(Message(text: DialogText(text: [text])), true);
  //     });
  //     log("Sent Message");
  //
  //     DetectIntentResponse response = await dialogFlowtter.detectIntent(
  //         queryInput: QueryInput(text: TextInput(text: text)));
  //
  //     log('Response Came');
  //     if (response.message == null) {
  //       log("No response");
  //       return;
  //     }
  //     setState(() {
  //       log("Bot message set state");
  //
  //       addMessage(response.message!);
  //     });
  //   }
  // }

  sendMessage(String text) async {
    if (text.isEmpty) {
      log("Empty Message");
    } else {
      setState(() {
        log("User message set state");
        addMessage(Message(text: DialogText(text: [text])), true);
      });
      log("Sent Message");

      try {
        DetectIntentResponse response = await dialogFlowtter.detectIntent(
            queryInput: QueryInput(text: TextInput(text: text)));

        log('Response Came');
        if (response.message == null) {
          log("No response");
          return;
        }
        setState(() {
          log("Bot message set state");
          addMessage(response.message!);
        });
      } catch (error) {
        log("Error during detection: $error");
        // Handle network error (display message, retry later, etc.)
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
    setState(() {

    });
  }
}
