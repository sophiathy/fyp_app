import 'package:geolocator/geolocator.dart';

class GeoService{
  //TODO: comment
  Stream<Position> getPosStream(){
    return Geolocator.getPositionStream();
  }

  Future<Position> getCurrentLocation() async{
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}