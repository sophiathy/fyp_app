import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp_app/theme/darkProvider.dart';
import 'package:fyp_app/services/geoService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class FinalMap extends StatefulWidget {
  final List<LatLng> route;

  FinalMap(this.route);

  @override
  _FinalMapState createState() => _FinalMapState();
}

class _FinalMapState extends State<FinalMap> {
  final GeoService geo = GeoService();
  Completer<GoogleMapController> _mapController = Completer();
  bool mapCreated = false;

  BitmapDescriptor sourcePin;
  BitmapDescriptor destinationPin;
  LatLng _source, _destination, _southwest, _northeast;

  Set<Marker> _pins = {}; //source and destination markers
  Set<Polyline> _polylines = {}; //path on map

  @override
  void initState() {
    super.initState();
    if (mounted) {
      initPins();
      _source = widget.route.first;
      _destination = widget.route.last;
    }
  }

  Future<void> mapStyle(GoogleMapController gc, String path) async {
    gc.setMapStyle(await rootBundle.loadString(path));
  }

  void initPins() async {
    sourcePin = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "assets/images/sourcePin.png",
    );

    destinationPin = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      "assets/images/destinationPin.png",
    );
  }

  void setPinsOnMap() {
    setState(() {
      //source
      _pins.add(Marker(
        markerId: MarkerId('source'),
        position: _source,
        icon: sourcePin,
      ));

      //destination
      _pins.add(Marker(
        markerId: MarkerId('destination'),
        position: _destination,
        icon: destinationPin,
      ));
    });
  }

  void setCameraOnPins() async {
    final GoogleMapController gc = await _mapController.future;

    double minLat = _polylines.first.points.first.latitude;
    double minLng = _polylines.first.points.first.longitude;
    double maxLat = _polylines.first.points.first.latitude;
    double maxLng = _polylines.first.points.first.longitude;

    //southwest's lat and lng must be < than northeast's
    _polylines.forEach((element) {
      element.points.forEach((pt) {
        if (pt.latitude < minLat)
          minLat = pt.latitude;
        if (pt.latitude > maxLat)
          maxLat = pt.latitude;

        if (pt.longitude < minLng)
          minLng = pt.longitude;
        if (pt.longitude > maxLng)
          maxLng = pt.longitude;
      });
    });

    //update values
    _southwest = LatLng(minLat, minLng);
    _northeast = LatLng(maxLat, maxLng);

    //must add a 1 second delay for the camera to update the location
    await Future.delayed(Duration(seconds: 1)).then((value) async {
      gc.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: _southwest,
            northeast: _northeast,
          ),
          20.0, //padding
        ),
      );
    });
  }

  void setPolylinesOnMap() async {
    setState(() {
      Polyline p = Polyline(
        polylineId: PolylineId('path'),
        color: Colors.redAccent,
        points: widget.route,
      );
      _polylines.add(p);
    });
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
            //when the map is ready, set the pins and polylines on map
            setPinsOnMap();
            setPolylinesOnMap();
            setCameraOnPins(); //animate the camera to focus on the pins
            if (modeSwitch.themeData)
              mapStyle(gc, "assets/map/darkMap.json"); //dark mode Map
            setState(() {});
          },
          mapType: MapType.normal, //default: normal map for light mode
          markers: _pins, //source and destination pins
          polylines: _polylines, //sets of polylines
          initialCameraPosition: CameraPosition(
            zoom: 18.0,
            target: widget.route.elementAt(widget.route.length ~/ 2),
          ),
        ),
      ),
    );
  }
}
