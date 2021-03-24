import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Posting extends StatefulWidget {
  @override
  PostingState createState() => PostingState();
}

class PostingState extends State<Posting> {
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  static const LatLng _mainLocation = const LatLng(25.69893, 32.6421);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _mainLocation,
        zoom: 10.0,
      ),
      markers: this.myMarker(),
      mapType: MapType.normal,
      onMapCreated: (controller) {
        setState(() {
          myMapController = controller;
        });
      },
    );
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_mainLocation.toString()),
        position: _mainLocation,
        infoWindow: InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }

}

