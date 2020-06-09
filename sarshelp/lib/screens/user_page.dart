import 'dart:async';

import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sarshelp/widgets/common.dart';

final dbRef = Firestore.instance.collection("Users");


class UserPage extends StatefulWidget {

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; 
  int count = 0;

  void _add({GeoPoint geoPoint}) {
    final MarkerId markerId = MarkerId('marker$count');
    count++;
    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        geoPoint.latitude,
        geoPoint.longitude,
      ),
    );

    markers[markerId] = marker;
  }

  CameraPosition _kGooglePlex({GeoPoint geoPoint}){
    return CameraPosition(
        target: LatLng( 37.43296265331129, -122.08832357078792),
        zoom: 14.4746,
      );
  } 

  @override
  Widget build(BuildContext context) {
  return FutureBuilder(
    future: _getuid(),
    builder: (context, AsyncSnapshot<FirebaseUser> user){
      if(user.hasData) {
        return FutureBuilder(
          future: dbRef.document(user.data.uid).get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if(snapshot.hasData){
              _add(geoPoint: snapshot.data['address'] as GeoPoint);
              return SizedBox(
                 height: 700,
                 child: 
                  Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top:10,left: 20.0,right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _getProfileImage(snapshot),
                            _getMap(snapshot)
                          ],	
                        ) ,
                      ),
                    ]
                )
                )
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

  _getProfileImage(snapshot) {
    return Container(child: Row(children: <Widget>[
      new Container(
          height: 70.0,
          width: 70.0,
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
            image:DecorationImage(
              image:  new ExactAssetImage('assets/benja.jpg'),
              fit: BoxFit.cover
            )
          )
        ),
      _getPersonalData(snapshot)

    ],),);
  }

  _getPersonalData(snapshot) {
    return 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
            SizedBox(
              width: 232,
              child:
                Text(
                  snapshot.data['name'] + ' ' + snapshot.data['lastName'],
                  textAlign:TextAlign.left,
                  textScaleFactor: 1.3,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                  style: new TextStyle(fontWeight: FontWeight.bold)),
            ),
            Text(
              Age
                .dateDifference(
                  fromDate: DateTime.fromMillisecondsSinceEpoch(snapshot.data['birthdate'].millisecondsSinceEpoch), 
                  toDate: new DateTime.now()
                ).years.toString() + ' años',
              textAlign:TextAlign.left,
              textScaleFactor: 1.3,
            ),
            Text(
              "Ciudadano",
              textAlign:TextAlign.left,
              textScaleFactor: 1.1,),
          ] 
      );
  }

  _getMap(AsyncSnapshot<DocumentSnapshot> snapshot) {
    return new Card(
        child: Container(
          height: 500,
          child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex(),
              markers: Set<Marker>.of( markers.values ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                controller.animateCamera(CameraUpdate.newCameraPosition(_userLocation(snapshot.data['address'])));
              },
            )
        )
    );
  }
  
}

CameraPosition _userLocation(GeoPoint geoPoint) {
  return CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(geoPoint.latitude, geoPoint.longitude),
    tilt: 29.440717697143555,
    zoom: 14.151926040649414
  );
}
        
Future<FirebaseUser> _getuid() async {
  return await FirebaseAuth.instance.currentUser();
}