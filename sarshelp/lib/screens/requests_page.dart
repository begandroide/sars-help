import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/widgets/common.dart';


final dbRef = Firestore.instance.collection("HelpRequests");

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
