import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/create_request.dart';
import 'package:sarshelp/widgets/common.dart';


final dbRef = Firestore.instance.collection("HelpRequests");


class RequestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: buildRequestsPage(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          onPressed(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }

  onPressed (BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateRequestPage()),
    );
  }
}

Widget buildRequestsPage(BuildContext context) {
  return FutureBuilder(
    future: FirebaseAuth.instance.currentUser(),
    builder: (context, AsyncSnapshot<FirebaseUser> user){
      if(user.hasData) {
        return FutureBuilder(
          future: dbRef.document(user.data.uid).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasData){
            return StreamBuilder<QuerySnapshot>(
              stream: dbRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return buildWaitingScreen();
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new ListTile(
                          title: new Text(document['description'].toString()),
                          subtitle: new Text(document['grade'].toString()),

                        );
                      }).toList(),
                    );
                }
              },
            );
            } else {
              return buildWaitingScreen();
            }
          }
        );
      } else {
        return buildWaitingScreen();
      }
    });
}
