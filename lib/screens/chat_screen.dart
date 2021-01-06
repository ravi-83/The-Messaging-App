import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/data/data_model.dart';
import 'package:messaging/data/data_source_firebase.dart';
import 'package:messaging/screens/home_screen.dart';
import 'package:messaging/utils/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'AuthenticationScreen.dart';

//final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class MainChatScreen extends StatefulWidget {
  final String peerId;
  final String currentId;
  final String name;
  final String url;
  final String email;
  final String currentUserUrl;
  MainChatScreen(
      {this.name,
      this.url,
      this.peerId,
      this.email,
      this.currentId,
      this.currentUserUrl});
  @override
  _MainChatScreenState createState() => _MainChatScreenState(email);
}

class _MainChatScreenState extends State<MainChatScreen> {
  final String email;
  final auth = FirebaseAuth.instance;
  String messageText;
  final messageTextController = TextEditingController();
  String groupChatId;
  final _auth = FirebaseAuthImpl();

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
            getImage(widget.url, 40),
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
            Icons.video_call_rounded,
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
              currentUserUrl: widget.currentUserUrl,
              otherSideUserUrl: widget.url,
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
              if (messageText != null) {
                print('${widget.email}');
                if (messageText.trim().isEmpty) {
                  Fluttertoast.showToast(
                    msg: 'Please enter some valid text',
                    backgroundColor: Color(0xffb71c1c),
                    gravity: ToastGravity.CENTER,
                  );
                } else {
                  try {
                    firestore
                        .collection('all_text')
                        .doc(groupChatId)
                        .collection(groupChatId)
                        .add({
                      'Message': messageText,
                      'fromUser': widget.currentId,
                      'toUser': widget.peerId,
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
                }
              } else {
                Fluttertoast.showToast(
                  msg: 'Type some message first',
                  backgroundColor: Color(0xffb71c1c),
                  gravity: ToastGravity.CENTER,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final _auth = FirebaseAuthImpl();
  final String email;
  final String chatId;
  final String currentUserUrl;
  final String otherSideUserUrl;

  MessageStream(
      {this.email, this.chatId, this.currentUserUrl, this.otherSideUserUrl});

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
          final sender = message.data()['fromUser'];
          final recever = message.data()['toUser'];
          final identity = message.data()['email'];
          final messageTime = message.data()['time'] as Timestamp; //add this
          final currentUser = _auth.currentUserEmail;
          print(identity);
          print(currentUser);
          print(messageText);

          final messageBubble = MessageBubble(
            sender: sender,
            recever: recever,
            text: messageText,
            isMe: currentUser == identity,
            time: messageTime,
            currentUserUrl: currentUserUrl,
            otherSideUserUrl: otherSideUserUrl, //add this
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 3, vertical: 20),
              children: messageBubbles),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String recever;
  final String text;
  final bool isMe;
  final Timestamp time;
  final String currentUserUrl;
  final String otherSideUserUrl;

  MessageBubble({
    this.text,
    this.sender,
    this.isMe,
    this.time,
    this.recever,
    this.currentUserUrl,
    this.otherSideUserUrl,
  });
  final DateFormat dateFormat = DateFormat.jm();
  //final String date= dateFormat.format(time.toDate());
  


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: isMe != true
          ? Padding(
              padding: EdgeInsets.only(right: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getImage(otherSideUserUrl, 40),
                   SizedBox(
                    width: 5,
                  ),
                  Flexible(child: buildMaterialTextDesign()),
                  //Text('${dateFormat.format(time.toDate())}'),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(left: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: buildMaterialTextDesign()),
                  SizedBox(
                    width: 5,
                  ),
                  getImage(currentUserUrl, 40),
                  //Text('${dateFormat.format(time.toDate())}'),
                ],
              ),
            ),
    );
  }

  Material buildMaterialTextDesign() {
    return Material(
      color: isMe == true ? Color(0xffDCF8C6) : Colors.white,
      elevation: 2,
      borderRadius: isMe == true
          ? BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )
          : BorderRadius.only(
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
      child: Container(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10,bottom: 20,left: 10,right: 50),
              child: Text(
                text,
                //textAlign: TextAlign.right,
                style: TextStyle(
                  color: isMe ? Colors.black : Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
            Positioned(
              bottom: 7,
              right: 12,
              child: Text(
                '${dateFormat.format(time== null ? DateTime.now() : time.toDate())}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600
                ),
                
                ),
                
              )
          ],
        ),
      ),
    );
  }

  Widget buildPaddingImageForChat(String userId) {
    return getcachedNetworkImage(userId, 30);
  }
}
