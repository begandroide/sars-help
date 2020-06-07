import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/widgets/common.dart';

final dbRef = Firestore.instance.collection("Users");

Widget showProfile(BuildContext context) {
  return FutureBuilder(
    future: _getuid(),
    builder: (context, AsyncSnapshot<FirebaseUser> user){
      if(user.hasData) {
        return FutureBuilder(
          future: dbRef.document(user.data.uid).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasData){
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[Expanded(
                      child: Container(
                        color: Colors.white,
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20.0,right: 40.0, top:100.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Ciudadano",
                                      textAlign:TextAlign.left,
                                      textScaleFactor: 1.3,
                                      style: new TextStyle(fontWeight: FontWeight.bold)),
                                    Text(
                                      snapshot.data['name'] + ' ' + snapshot.data['lastName'],
                                      textAlign:TextAlign.left,
                                      textScaleFactor: 1.3,),
                                    Text(
                                      DateTime.fromMillisecondsSinceEpoch(snapshot.data['birthdate'].millisecondsSinceEpoch).toString(),
                                      textAlign:TextAlign.left,
                                      textScaleFactor: 1.3,
                                    ),
                                  ],	
                                ) ,
                              ),
                            ]
                          )
                      )
                    )]
                  ),
                  // Profile image
                  Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                        image:DecorationImage( image:  new ExactAssetImage('assets/benja.jpg'),
                        fit: BoxFit.cover)
                      )))
                ]
              );
            } else {
              return buildWaitingScreen();
            }
          }
        );
      } else {
        return buildWaitingScreen();
      }
    }
  );
}
        
Future<FirebaseUser> _getuid() async {
  return await FirebaseAuth.instance.currentUser();
}