import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowMap extends StatefulWidget {
  final Position initPos;

  ShowMap(this.initPos);

  @override
  _ShowMapState createState() => _ShowMapState();
}

class _ShowMapState extends State<ShowMap> {
  final GeoService geo = GeoService();
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState(){
    super.initState();
    geo.getPosStream().listen((pos) => keepUserCenter(pos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GoogleMap(
          onMapCreated: (GoogleMapController gc) => _mapController.complete(gc),  //assign map controller
          myLocationEnabled: true,
          mapType: MapType.normal,                //TODO: comment and change style
          initialCameraPosition: CameraPosition(
            zoom: 18.0,
            target: LatLng(
              widget.initPos.latitude,
              widget.initPos.longitude),
            ),
        ),
      ),
    );
  }

  Future keepUserCenter(Position pos) async{
    final GoogleMapController gc = await _mapController.future;

    gc.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        zoom: 18.0,
        target: LatLng(
          widget.initPos.latitude,
          widget.initPos.longitude),
      ),
    ));
  }
}