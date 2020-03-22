import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser userdetails;
  HomePage({Key key, this.userdetails}) : super (key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GoogleMapController mapController;
  TextEditingController editingController = TextEditingController();
  Geoflutterfire geo = Geoflutterfire();
  Stream<dynamic> query;
  StreamSubscription subscription;
  Location _location = Location();

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _fireStore = Firestore.instance;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  BehaviorSubject<double> radius = BehaviorSubject.seeded(0.25);

  void _updateLocations() async {
    var currentLocation =  await _location.getLocation();
    LatLng latlng = LatLng(currentLocation.latitude, currentLocation.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: latlng,
      tilt: 0,
      zoom: 15
    )));
    _radiusListener(currentLocation);
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    _markers= {};
    documentList.forEach((DocumentSnapshot document) {
        GeoPoint pos = document.data['position']['geopoint'];
        final MarkerId markerId = MarkerId(document.documentID);
        var marker = Marker(
          position: LatLng(pos.latitude, pos.longitude),
          markerId: markerId
        );
      setState(() {
        _markers[markerId] = marker;
      });
    });
  }

  _radiusListener(LocationData currentLocation) async {
    var ref = _fireStore.collection('first_aid');
    GeoFirePoint center = geo.point(latitude: currentLocation.latitude, longitude: currentLocation.longitude);
    subscription = radius.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
        center: center, 
        radius: rad, 
        field: 'position', 
        strictMode: true,
      );
    }).listen(_updateMarkers);
  }

  _updateQuery(value) {
    setState(() {
      radius.add(value);
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HOME", style: TextStyle(fontSize: 17)),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(target: LatLng(37.4219999, -122.0862462)),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            mapToolbarEnabled: false,
            markers: Set<Marker>.of(_markers.values),
          ),
          // Padding(             Search box yet to be implemented
          //   padding: const EdgeInsets.only(left:10.0, right:10.0, top:5.0),
          //   child: TextField(
          //     onChanged: (value) {
          //       // search implementation
          //     },
          //     controller: editingController,
          //     style: TextStyle(color: Colors.red),
          //     decoration: InputDecoration(
          //       hintText: "Search...",
          //       hintStyle: TextStyle(color: Colors.red[200]),
          //       prefixIcon: Icon(Icons.search, color: Colors.red),
          //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
          //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[100]))
          //     )
          //   )
          // ),
          Positioned(
            bottom: 20,
            left: 10,
            width: MediaQuery.of(context).size.width/1.3,
            child: Slider(
              min: 0.25,
              max: 2.5, 
              divisions: 9,
              value: radius.value,
              label: 'Radius ${radius.value}km',
              activeColor: Colors.lightBlueAccent,
              inactiveColor: Colors.lightBlueAccent.withOpacity(0.2),
              onChanged: _updateQuery,
            )
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: FlatButton(
              splashColor: Colors.white,
              highlightColor: Theme.of(context).hintColor,
              child: Text(
                "Logout ${widget.userdetails.displayName}",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                _auth.signOut();
              },
            )   
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.my_location),
        onPressed: () {
          _updateLocations();
        }
      ) 
    );
  }
}