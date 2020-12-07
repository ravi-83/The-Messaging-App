import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AuthenticationScreen.dart';


// CollectionReference store=FirebaseFirestore.instance.collection('message');

class ChatScreen extends StatefulWidget {

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  Future getData()async{
    var firestore=FirebaseFirestore.instance;
    QuerySnapshot query= await firestore.collection('message').get();
    return query.docs;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10,bottom: 5,left: 15,right: 15),
            height: 250,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
              color: Colors.blueAccent.shade700,
                boxShadow: [BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                ),]
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.drag_indicator,color: Colors.white,),
                      Text(
                        'Messages',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      imageProfile(50,),
                    ],
                  ),
                  SizedBox( height: 40,),
                  Container(
                    height: 75,
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        imageIcon(45),
                        SizedBox( width: 20,),
                        peopleForChat(height: 45,width: 65,url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                        SizedBox( width: 20,),
                        peopleForChat(height: 45,width: 65,url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80'),
                        SizedBox( width: 20,),
                        peopleForChat(height: 45,width: 65,url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                        SizedBox( width: 20,),
                        peopleForChat(height: 45,width: 65,url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                        // SizedBox( width: 20,),
                        // imageProfile(45),
                      ],
                    ),
                  ),
                ],

              ),
            ),
          ),
          Expanded(child: chatList()),
        ],
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
              IconButton(icon: Icon( Icons.message), onPressed: null,color: Colors.black54,),
              IconButton(icon: Icon( Icons.call), onPressed: null,color: Colors.black54,),
              IconButton(icon: Icon( Icons.account_circle_outlined), onPressed: null,color: Colors.black54,),
              IconButton(icon: Icon( Icons.settings), onPressed: null,color: Colors.black54,)
            ],

          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget chatList(){
    return ListView(
      //shrinkWrap: true,
      //scrollDirection: Axis.vertical,
      children: list,

    );
  }
  List<ListTile> list= [
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Team Message',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi ! Welcome'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
        height: 45,
        width: 45,
        url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
        height: 45,
        width: 45,
        url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
        height: 45,
        width: 45,
        url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
        height: 45,
        width: 45,
        url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
    ListTile(
      leading: peopleForChat(
          height: 45,
          width: 45,
          url: 'https://images.unsplash.com/photo-1508901706-0f1b882dc1f5?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTZ8fGhhbGZ8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=600&q=60'
      ),
      title: Text('Angle Queen',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Hi! are you there?'),
    ),
    ListTile(
      leading: peopleForChat(
        height: 45,
        width: 45,
        url: 'https://images.unsplash.com/photo-1561677843-39dee7a319ca?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80',
      ),
      title: Text('Irish Man',style: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),),
      subtitle: Text('Lets party tonight! Hotel nagarjun'),
    ),
  ];
}

// Center(
// child: FutureBuilder(
// future: getData(),
// builder:
// (BuildContext context, snapshot) {
//
// if (snapshot.hasError) {
// return Text("Something went wrong");
// }
//
// if (snapshot.connectionState == ConnectionState.done) {
// DocumentSnapshot data = snapshot.data[1];
// return Center(child: Text('${data['password']}'));
// }
//
// return Text("loading");
// },
// ),
// ),


Widget imageProfile(double size){
  return Container(
   height: size,
    width: size,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
        fit: BoxFit.cover,
      ),
      border: Border.all(color: Colors.white38,width: 2),
      borderRadius: BorderRadius.all(Radius.circular(10)),

    ),
  );

}

Widget peopleForChat({double height,double width, String url}){
  return Container(
    height: height+10,
    width: width+20,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(url),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.black26,width: 2)

    ),
  );

}


Widget imageIcon(double size){
  return Container(
    height: size,
    width: size+30,
    decoration: BoxDecoration(

      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.grey,
      border: Border.all(color: Colors.black26),

    ),
    child: Icon(Icons.search_outlined,size: 40,),
  );

}





