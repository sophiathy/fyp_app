import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ShowMap extends StatefulWidget {
  final Position startPos;

  ShowMap(this.startPos);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final GeoService geo = GeoService();
  Completer<GoogleMapController> _mapController = Completer();
  bool mapCreated = false;

  @override
  void initState() {
    super.initState();
    geo.getPosStream().listen((pos) => keepUserCenter(pos));
  }

  Future<void> mapStyle(GoogleMapController gc, String path) async {
    gc.setMapStyle(await rootBundle.loadString(path));
  }

  @override
  Widget build(BuildContext context) {
    DarkProvider modeSwitch = Provider.of<DarkProvider>(context);

    return Scaffold(
      body: Center(
        child: GoogleMap(
          onMapCreated: (GoogleMapController gc) {
            mapCreated = true;
            _mapController.complete(gc);
            if (modeSwitch.themeData)
              mapStyle(gc, "assets/map/darkMap.json"); //dark mode Map
            setState((){});
          },
          myLocationEnabled: true,
          mapType: MapType.normal, //TODO: comment
          initialCameraPosition: CameraPosition(
            zoom: 18.0,
            target: LatLng(widget.startPos.latitude, widget.startPos.longitude),
          ),
        ),
      ),
    );
  }

  Future<void> keepUserCenter(Position movingPos) async {
    final GoogleMapController gc = await _mapController.future;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    //TODO: add dialog for location permission
    if (!isLocationServiceEnabled)
      LocationPermission permission = await Geolocator.requestPermission();

    gc.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 18.0,
        target: LatLng(movingPos.latitude, movingPos.longitude),
      ),
    ));
  }
}
