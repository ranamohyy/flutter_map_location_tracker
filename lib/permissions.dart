import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class PermissionHandler{
  PermissionHandler._handle();
  static final PermissionHandler _permissionHandler=PermissionHandler._handle();
  factory PermissionHandler()=>_permissionHandler;
  Future<void>getPermissionLocation()async{
    bool locationAllowedPermission=await Geolocator.isLocationServiceEnabled();
    if(!locationAllowedPermission){
      await Geolocator.openLocationSettings();
      return;
    }
    LocationPermission locationPermission= await Geolocator.checkPermission();
    switch (locationPermission) {
      case LocationPermission.denied :
         locationPermission = await Geolocator.requestPermission();
         if(locationPermission == LocationPermission.denied){
           return;
         }
        break;
      case LocationPermission.deniedForever:
        return;
      case LocationPermission.whileInUse:
        break;
      case LocationPermission.always:
      case LocationPermission.unableToDetermine:
      debugPrint("Unable to determine permission status");
      return;
    }



  }



}