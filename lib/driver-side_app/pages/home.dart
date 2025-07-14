import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../variables/gloabl-var.dart';


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {

  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosition;

  @override

  void initState() {
    super.initState();
    checkPermissionsAndLiveLocation();
  }

  Future<void> checkPermissionsAndLiveLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }
    LiveLocation();
  }
  void mapTheme(GoogleMapController controller) {
    jsonFile("map/night-style.json").then((value) => mapStyle(value, controller));
  }

  Future<String> jsonFile(String path) async {
    try {
      var byteData = await rootBundle.load(path);
      var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return utf8.decode(list);
    } catch (e) {
      print("Error loading map style JSON: $e");
      return '';
    }
  }

  void mapStyle(String googleMapStyle, GoogleMapController controller) {
    if (googleMapStyle.isNotEmpty) {
      controller.setMapStyle(googleMapStyle);
    } else {
      print("Map style JSON is empty.");
    }
  }

  Future<void> LiveLocation() async {
    Position userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = userPosition;

    LatLng positionConversion = LatLng(currentPosition!.latitude, currentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: positionConversion, zoom: 20);
    controllerGoogleMap?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              mapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);
              LiveLocation();
            },
          ),
        ],
      ),
    );
  }
}
