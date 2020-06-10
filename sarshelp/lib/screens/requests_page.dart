import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/create_request.dart';
import 'package:sarshelp/widgets/common.dart';


final dbRef = Firestore.instance.collection("HelpRequests");


class RequestsPage extends StatefulWidget {
  @override
  _RequestsPageState createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      body: buildRequestsPage(),
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

  Widget buildRequestsPage() {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, AsyncSnapshot<FirebaseUser> user){
        if(user.hasData) {
          return FutureBuilder(
            future: dbRef.document(user.data.uid).collection('userRequests').getDocuments(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
              if(snapshot.hasData){
              return StreamBuilder<QuerySnapshot>(
                stream: dbRef.document(user.data.uid).collection('userRequests').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return buildWaitingScreen();
                    default:
                      return new ListView(
                        padding: EdgeInsets.all(8),
                        children: snapshot.data.documents.map((DocumentSnapshot document) {
                          return new Card(
                            child: Container(
                              child: Column(children: <Widget>[
                                ListTile(
                                  leading: _getLeadingListTile(document),
                                  title: new Text(document['shortName'].toString()),
                                  subtitle: _getSubtitleListTile(document),
                                  trailing: new Icon(Icons.more_vert),
                                  isThreeLine: true,
                                ),
                                Row(children: <Widget>[
                                ],)
                              ],),),

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

  _getLeadingListTile(DocumentSnapshot document) {
    if(document['isClosed']) {
      return new Icon(Icons.check);
    } return new Icon(Icons.error); 
  }

  _getSubtitleListTile(DocumentSnapshot document) {
    return 
    Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(DateTime.fromMillisecondsSinceEpoch(document['datetime'].millisecondsSinceEpoch).toString()),
          Chip(
            label: Text(document['grade'].toString(), style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.pink,
          ),
      ]
    )
    );
  }
}
