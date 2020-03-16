import 'dart:async';
import 'dart:typed_data';
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
  StreamSubscription _locationSubscription;
  Location _location = Location();
  Marker marker;
  Circle circle;

  Future<Uint8List> _getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/current_location.png");
    return byteData.buffer.asUint8List();
  }

  void _getLocation() async {
    var location = await _location.getLocation();
    Uint8List _image = await _getMarker();
    _updateMarker(location, _image);

    if (_locationSubscription != null)
      _locationSubscription.cancel();

    _locationSubscription = _location.onLocationChanged().listen((currentLocation){
      if(mapController != null) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          tilt: 0,
          zoom: 18
        )));
        _updateMarker(currentLocation, _image);
      }
    });
  } 

  void _updateMarker(LocationData currentLocation, Uint8List image){
    LatLng latlng = LatLng(currentLocation.latitude, currentLocation.longitude);
    print(currentLocation);
    this.setState(() {
      marker = Marker(
        markerId: MarkerId("current"),
        position: latlng,
        flat: true,
        zIndex: 2,
        anchor: Offset(0.5, 0.5),
        icon: BitmapDescriptor.fromBytes(image)
      );
      circle = Circle(
        circleId: CircleId("marker"),
        radius: currentLocation.accuracy,
        zIndex: 1,
        strokeColor: Colors.blue.withAlpha(30),
        center: latlng,
        fillColor: Colors.blue.withAlpha(70)
      );
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null)
      _locationSubscription.cancel();
    super.dispose();
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
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
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
