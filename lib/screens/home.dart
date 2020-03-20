import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleMapController mapController;
  Location _location = Location();

  void _getLocation() async {
    var location = await _location.getLocation();
    _updateMarker(location);
  } 

  void _updateMarker(LocationData currentLocation){
    LatLng latlng = LatLng(currentLocation.latitude, currentLocation.longitude);
    mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: latlng,
      tilt: 0,
      zoom: 16
    )));
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
      body: Center(
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _auth.currentUser(),
              builder: (BuildContext context, AsyncSnapshot user) {
                if (user.connectionState == ConnectionState.waiting) {
                  return CupertinoActivityIndicator(
                    animating: true,
                    radius: 10,
                  );
                } 
                else {
                  return Expanded(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(target: LatLng(37.4219999, -122.0862462)),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                      mapToolbarEnabled: false,
                    ),
                  );
                }
              },
            ),
            FlatButton(
              splashColor: Colors.white,
              highlightColor: Theme.of(context).hintColor,
              child: Text(
                "Logout",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                _auth.signOut();
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.my_location),
        onPressed: () {
          _getLocation();
        }
      ) 
    );
  }
}