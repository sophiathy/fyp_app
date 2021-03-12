import 'package:geolocator/geolocator.dart';

class GeoService{
  Stream<Position> getPosStream(){
    return Geolocator.getPositionStream();
  }

  Future<Position> getCurrentLocation() async{
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}