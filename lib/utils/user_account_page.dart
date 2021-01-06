import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:messaging/AuthServices/services.dart';
import 'package:messaging/screens/AuthenticationScreen.dart';
import 'package:messaging/utils/access_camera.dart';
import 'package:messaging/utils/cached_network_image.dart';
import 'package:uuid/uuid.dart';

class UserAccountPage extends StatefulWidget {
  final String userId;
  UserAccountPage({Key key, this.userId}) : super(key: key);

  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  final FirebaseAuthImpl _authImpl = FirebaseAuthImpl();

  _changeImageOfTheUser() async {
    final url = await AccessCamera().getImageGallery();
    final imageUrl = await uploadImage(url);
    print(imageUrl);
    await fireStore
        .collection('message')
        .doc(widget.userId)
        .update({'image': imageUrl});
  }

  @override
  Widget build(BuildContext context) {
    print('${widget.userId}**************************S');
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        backgroundColor: Colors.blueAccent.shade700,
        centerTitle: true,
        elevation: 5,
      ),
      body: StreamBuilder(
          stream: fireStore
              .collection('message')
              .doc('${widget.userId}')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Somthing went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    getImage(snapshot.data['image'], 120),
                    IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          _changeImageOfTheUser();
                          //setState(() {});
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          _authImpl.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AuthenticationScreen()));
                        },
                        color: Colors.blueAccent,
                        child: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<String> uploadImage(var imageFile) async {
    var uuid = Uuid().v1();
    Reference ref = FirebaseStorage.instance.ref().child("post_$uuid.jpg");
    UploadTask uploadTask = ref.putFile(imageFile);

    String downloadUrl =
        await uploadTask.then((uploadTask) => ref.getDownloadURL());
    return downloadUrl;
  }
}
