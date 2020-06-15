import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sarshelp/screens/create_request.dart';
import 'package:sarshelp/widgets/common.dart';
import 'package:age/age.dart';

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
                stream: dbRef.document(user.data.uid).collection('userRequests').orderBy('datetime', descending: true).snapshots(),
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
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[_getLeadingListTile(document)]
                                  ),
                                  title: new Text(document['shortName'].toString()),
                                  subtitle: _getSubtitleListTile(document),
                                  trailing:  PopupMenuButton<String>(
                                    onSelected: (value) => {
                                      if(value == 'resolved'){
                                        FirebaseAuth.instance.currentUser().then((value) => {
                                          Firestore.instance.collection('HelpRequests/' + value.uid + '/userRequests').document(document.documentID).updateData({
                                            'datetime': document['datetime'],
                                            'description': document['description'],
                                            'grade': document['grade'],
                                            'shortName': document['shortName'],
                                            'isClosed': true,
                                            'endDate': DateTime.now()
                                          }).whenComplete(() => 
                                          {
                                          }
                                          )
                                      })
                                    }
                                    },
                                    itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                                      const PopupMenuItem<String>(
                                      value: 'resolved',
                                      child: Text('Marcar como Resuelta')
                                      ),],
                                  ),
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
      return new Icon(Icons.check, color: Colors.green);
    } return new Icon(Icons.error, color: Colors.redAccent); 
  }

  _getSubtitleListTile(DocumentSnapshot document) {
    return 
    Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text( 'Registrado hace ' +  Age.dateDifference( fromDate: DateTime.fromMillisecondsSinceEpoch(document['datetime'].millisecondsSinceEpoch), toDate: new DateTime.now() ).days.toString() + ' días'),
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Transform(
                transform: new Matrix4.identity()..scale(0.9),
                child: new Chip(
                  label: new Text(
                    document['isClosed'] ? 'Resuelta' : "Abierta",
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(color: Colors.white),
                  ),
                  backgroundColor: document['isClosed'] ? Colors.green : Colors.redAccent,
                ),
              ),
              RichText(
                text: TextSpan(
                  text:'Nivel: ',
                  style: TextStyle(color: Colors.black, fontSize: 12.0),
                  children: <TextSpan>[
                    TextSpan(text: document['grade'].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                  ] 
                ),
              ),
            ]
          )
      ]
    )
    );
  }
}
