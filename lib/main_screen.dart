import 'package:add_marker_for_google_maps/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final MapController _mapController = MapController();
  LatLng currentPoint = LatLng(30.0444, 31.2357);
  Future<void> getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPoint = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(currentPoint, 13);
  }
  Future<void>init()async{
    PermissionHandler permissionHandler=PermissionHandler();
    await permissionHandler.getPermissionLocation();
    await getUserLocation();

  }
  @override
  void initState() {
    super.initState();
    init();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Map Example"),
      ),
      body: FlutterMap(
        mapController:  _mapController,

        options: MapOptions(
          initialCenter: currentPoint,
          initialZoom: 20,
          onTap: (tapPosition, latLng) {
            setState(() {
              currentPoint = latLng;
            });
          },
        ),
        children: [
          TileLayer(
            //all templates
            // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            urlTemplate: "https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
            // urlTemplate: "https://tile.opentopomap.org/{z}/{x}/{y}.png",

            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: currentPoint,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Lat: ${currentPoint.latitude}, Lng: ${currentPoint.longitude}"),
            ),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
