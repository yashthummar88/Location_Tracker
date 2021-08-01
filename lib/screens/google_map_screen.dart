import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  @override
  _GoogleMapScreenState createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  double longitude = 0, latitude = 0;

  Set<Marker> _marker = {};
  GoogleMapController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              _controller.dispose();
              Navigator.of(context).pop();
            });
          },
        ),
        title: Text("Google Map"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _marker.add(Marker(
                      markerId: MarkerId("id-1"),
                      position: LatLng(latitude, longitude)));
                  _controller.animateCamera(
                      CameraUpdate.newLatLng(LatLng(latitude, longitude)));
                });
              },
              icon: Icon(Icons.refresh)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.animateCamera(
                CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          });
        },
        child: Icon(Icons.gps_fixed),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
            _marker.add(Marker(
                markerId: MarkerId("id-1"),
                position: LatLng(latitude, longitude)));
            _controller.animateCamera(
                CameraUpdate.newLatLng(LatLng(latitude, longitude)));
          });
        },
        markers: _marker,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        mapType: MapType.hybrid,
      ),
    );
  }

  _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // setState(() {
    //   loading = true;
    // });
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Geolocator.getPositionStream().listen((Position position) {
        setState(() {
          longitude = position.longitude;
          latitude = position.latitude;

          // loading = false;
        });
      });
    }
  }
}
