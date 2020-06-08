import 'dart:async';

import 'package:age/age.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sarshelp/widgets/common.dart';

final dbRef = Firestore.instance.collection("Users");


class UserPage extends StatelessWidget {

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

  void _add({GeoPoint geoPoint}) {
    final MarkerId markerId = MarkerId('markerIdVal');

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

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
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
              return Expanded(
                child:  Stack(
                alignment: Alignment.center,
                children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20.0,right: 40.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
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
                                        ))),
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
                                      Age.dateDifference(fromDate: DateTime.fromMillisecondsSinceEpoch(snapshot.data['birthdate'].millisecondsSinceEpoch), toDate: new DateTime.now()).toString(),
                                      textAlign:TextAlign.left,
                                      textScaleFactor: 1.3,
                                    ),
                                    Card(

                                      child:Container(height: 400,child: 
                                    GoogleMap(
                                        mapType: MapType.hybrid,
                                        initialCameraPosition: _kGooglePlex(),
                                        markers: Set<Marker>.of( markers.values ),
                                        onMapCreated: (GoogleMapController controller) {
                                          _controller.complete(controller);
                                          controller.animateCamera(CameraUpdate.newCameraPosition(_userLocation(snapshot.data['address'])));
                                      },
                                    )
                                      ,)
                                    )
                                  ],	
                                ) ,
                              ),
                            ]
                          )
                    ]
                  )
                  // Profile image
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

}
CameraPosition _userLocation(GeoPoint geoPoint) {
  return CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(geoPoint.latitude, geoPoint.longitude),
    tilt: 59.440717697143555,
    zoom: 16.151926040649414
  );
}
        
Future<FirebaseUser> _getuid() async {
  return await FirebaseAuth.instance.currentUser();
}