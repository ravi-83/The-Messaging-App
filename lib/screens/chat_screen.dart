import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messaging/screens/home_screen.dart';
import 'AuthenticationScreen.dart';

//final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class MainChatScreen extends StatefulWidget {
  final String peerId;
  final String currentId;
  final String name;
  final String url;
  final String email;
  MainChatScreen(
      {this.name, this.url, this.peerId, this.email, this.currentId});
  @override
  _MainChatScreenState createState() => _MainChatScreenState(email);
}

class _MainChatScreenState extends State<MainChatScreen> {
  final String email;
  final auth = FirebaseAuth.instance;
  String messageText;
  final messageTextController = TextEditingController();
  String groupChatId;

  _MainChatScreenState(this.email);

  @override
  void initState() {
    super.initState();
    getUserInstance();
  }

  void getUserInstance() async {
    if (widget.currentId.hashCode <= widget.peerId.hashCode) {
      groupChatId = '${widget.currentId}-${widget.peerId}';
      print('$groupChatId*********#####');
    } else {
      groupChatId = '${widget.peerId}-${widget.currentId}';
      print('$groupChatId###########');
    }
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.blue,
            size: 30,
          ),
        ),
        title: Row(
          children: [
            buildImageOfUserFromFirebase(),
            SizedBox(
              width: 20,
            ),
            buildNameOfTheUserFromFirebase(),
          ],
        ),
        actions: [
          Icon(
            Icons.call,
            size: 30,
            color: Colors.blue,
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.video_call_sharp,
            size: 40,
            color: Colors.blue,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(
              email: widget.email,
              chatId: groupChatId,
            ),
            typeYourMessageHere(),
          ],
        ),
      ),
    );
  }

  buildImageOfUserFromFirebase() {
    return CircleAvatar(
      backgroundColor: Colors.blue,
      backgroundImage: NetworkImage(
        widget.url,
      ),

      //child: Icon(Icons.supervised_user_circle),
    );
  }

  buildNameOfTheUserFromFirebase() {
    return Text(
      '${widget.name.split(' ')[0]}',
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  typeYourMessageHere() {
    return Container(
      // margin: EdgeInsets.only(top: 10,bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xffF0F0F0),
        // border: Border(
        //   top: BorderSide(color: Color(0xffF0F0F0), width: 2.0),
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.insert_emoticon_rounded,
              color: Colors.grey[600],
              size: 30,
            ),
            onPressed: () {
              // messageTextController.clear();
              // _fireStore.collection('message').add({
              //   'Message': messageText,
              //   'Sender': loggedInUser.email,
              //   'time': FieldValue.serverTimestamp(),
              // });
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: messageTextController,
                onChanged: (value) {
                  messageText = value;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'type your message',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffF0F0F0), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffF0F0F0), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.grey[600],
              size: 30,
            ),
            onPressed: () {
              messageTextController.clear();
              print('${widget.email}');

              try {
                // print('*****************************************');
                // var documentReference = firestore
                //     .collection('all_text')
                //     .doc(groupChatId)
                //     .collection(groupChatId)
                //     .doc(DateTime.now().millisecondsSinceEpoch.toString());

                // fireStore.runTransaction((transaction) async {
                //     transaction.set(documentReference, {
                //       'idFrom' : widget.currentId,
                //       'idTo' : widget.peerId,
                //       'timeStamp'  : DateTime.now().millisecondsSinceEpoch.toString(),
                //       'Message' : messageText,
                //       'image' :widget.url,
                //       'email' : loggedInUser.email,
                //   });

                // });
                firestore
                    .collection('all_text')
                    .doc(groupChatId)
                    .collection(groupChatId)
                    .add({
                  'Message': messageText,
                  'image': widget.url,
                  'email': loggedInUser.email,
                  'time': FieldValue.serverTimestamp(),
                });
              } catch (e) {
                Fluttertoast.showToast(
              msg: e.code.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              //timeInSecForIos: 1
              );
                print(e.code);
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final String email;
  final String chatId;

  MessageStream({this.email, this.chatId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore
          .collection('all_text')
          .doc(chatId)
          .collection(chatId)
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Fluttertoast.showToast(
              msg: snapshot.error.toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              //timeInSecForIos: 1
              );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }

        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['Message'];
          final senderImage = message.data()['image'];
          final identity = message.data()['email'];
          final messageTime = message.data()['time'] as Timestamp; //add this
          final currentUser = loggedInUser.email;
          print(identity);
          print(currentUser);
          print(messageText);

          final messageBubble = MessageBubble(
            sender: senderImage,
            text: messageText,
            isMe: currentUser == identity,
            time: messageTime, //add this
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageBubbles),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  MessageBubble({
    this.text,
    this.sender,
    this.isMe,
    this.time,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: isMe != true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildPaddingImageForChat(),
                buildMaterialTextDesign(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildMaterialTextDesign(),
                buildPaddingImageForChat(),
              ],
            ),
    );
  }

  Material buildMaterialTextDesign() {
    return Material(
      color: isMe == true ? Color(0xffDCF8C6) : Colors.white,
      elevation: 5,
      borderRadius: isMe == true
          ? BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            )
          : BorderRadius.only(
              topRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Container(
          child: Text(
            text,
            //textAlign: TextAlign.right,
            style: TextStyle(
              color: isMe ? Colors.black : Colors.black,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Padding buildPaddingImageForChat() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: CircleAvatar(
        backgroundImage: NetworkImage(sender),
      ),
    );
  }
}
