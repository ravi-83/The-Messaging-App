import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/data/data_model.dart';
import 'package:messaging/utils/cached_network_image.dart';
import 'package:messaging/utils/user_account_page.dart';
import 'package:messaging/data/data_source_firebase.dart';
//import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'AuthenticationScreen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

// CollectionReference store=FirebaseFirestore.instance.collection('message');

final String img =
    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';

var firestore = FirebaseFirestore.instance;

CollectionReference user = firestore.collection('message');

class ChatScreen extends StatefulWidget {
  final String ref;
  final String userDocId;

  ChatScreen({this.ref, this.userDocId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Future getData() async {
  //   QuerySnapshot query = await firestore.collection('message').get();
  //   return query.docs;
  // }
  final RefreshController controller = RefreshController();
  final _auth = FirebaseAuthImpl();

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Double press to back');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 15),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Colors.blueAccent.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ]),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.drag_indicator,
                          color: Colors.white,
                        ),
                        Text(
                          'Messages',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserAccountPage(
                                            userId: widget.ref,
                                          )));
                            },
                            child: getProfileImage(widget.ref, 50)),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: [
                            imageIcon(45),
                            SizedBox(
                              width: 20,
                            ),
                            peopleForChat(
                                size: 45,
                                url:
                                    'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                            SizedBox(
                              width: 20,
                            ),
                            peopleForChat(
                                size: 45,
                                url:
                                    'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'),
                            SizedBox(
                              width: 20,
                            ),
                            peopleForChat(
                                size: 45,
                                url:
                                    'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                            SizedBox(
                              width: 20,
                            ),
                            peopleForChat(
                                size: 45,
                                url:
                                    'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                            SizedBox(
                              width: 20,
                            ),
                            peopleForChat(
                              size: 45,
                              url:
                                  'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: chatList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 4,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.message),
                onPressed: null,
                color: Colors.black54,
              ),
              IconButton(
                icon: Icon(Icons.call),
                onPressed: null,
                color: Colors.black54,
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined),
                onPressed: null,
                color: Colors.black54,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: null,
                color: Colors.black54,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget chatList() {
    String currentUserUrl;
    return StreamBuilder<QuerySnapshot>(
        stream: user.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Somthing went wrong !!');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView(
              //shrinkWrap: true,
              //scrollDirection: Axis.vertical,
              children: snapshot.data.docs.map((e) {
            if (e.data()['email'] == _auth.currentUserEmail) {
              currentUserUrl = e.data()['image'];
            }
            if (e.data()['email'] != _auth.currentUserEmail) {
              return Column(
                children: [
                  Card(
                    elevation: 2,
                    child: ListTile(
                      leading: getImage(e.data()['image'], 50),
                      title: Text(
                        '${e.data()['name']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('Heyy!! Welcome to Messages'),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MainChatScreen(
                            name: e.data()['name'],
                            url: e.data()['image'],
                            email: e.data()['email'],
                            currentUserUrl: currentUserUrl,
                            currentId: widget.ref,
                            peerId: e.data()['id'],
                          );
                        }));
                      },
                    ),
                  ),
                  // Divider(
                  //   //color: Colors.black38,
                  //   height: 10,
                  //   //thickness: 1,
                  // )
                ],
              );
            } else {
              return Container();
            }
          }).toList());
        });
  }

  Widget imageProfile(double size) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: Colors.white38, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  Widget peopleForChat({double size, String url}) {
    return Container(
      width: size + 20,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: Colors.black26, width: 2)),
    );
  }

  Widget imageIcon(double size) {
    return Container(
      width: size + 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey,
        border: Border.all(color: Colors.black26),
      ),
      child: Icon(
        Icons.search_outlined,
        size: 40,
      ),
    );
  }
}
