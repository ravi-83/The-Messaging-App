import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messaging/screens/AuthenticationScreen.dart';

Widget getcachedNetworkImage(String userId, double size) {
  return StreamBuilder(
    stream: fireStore.collection('message').doc(userId).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error');
      } else {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data['image'],
            imageBuilder: (context, imageProvider) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                //borderRadius: BorderRadius.all(Radius.circular(10)),
                //border: Border.all(color: Colors.black26, width: 2),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        }
      }
    },
  );
}

Widget getImage(String url, double size) {
  return CachedNetworkImage(
    imageUrl: url,
    imageBuilder: (context, imageProvider) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        //borderRadius: BorderRadius.all(Radius.circular(10)),
        //border: Border.all(color: Colors.black26, width: 2),
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => CircularProgressIndicator(),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}



Widget getProfileImage(String userId, double size) {
  return StreamBuilder(
    stream: fireStore.collection('message').doc(userId).snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error');
      } else {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          return CachedNetworkImage(
            imageUrl: snapshot.data['image'],
            imageBuilder: (context, imageProvider) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white38, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          );
        }
      }
    },
  );
}
