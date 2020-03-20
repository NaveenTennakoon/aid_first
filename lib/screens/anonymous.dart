import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AnonymousPage extends StatefulWidget {
  @override
  _AnonymousPageState createState() => _AnonymousPageState();
}

class _AnonymousPageState extends State<AnonymousPage> {
  TextEditingController editingController = TextEditingController();
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
      appBar: AppBar(
        title: Text('AID FIRST', style: TextStyle(fontSize: 17)),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.close),
          alignment: Alignment.center,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (value) {
                  // search implementation
                },
                controller: editingController,
                style: TextStyle(color: Colors.red),
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.red[200]),
                  prefixIcon: Icon(Icons.search, color: Colors.red),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 2.0)),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red[100]))
                )
              )
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(target: LatLng(37.4219999, -122.0862462)),
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                mapToolbarEnabled: false,
              ),
            ),        
          ]
        )
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
