// ignore_for_file: prefer_typing_uninitialized_variables
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  LatLng? _currentPosition;
  loc.Location location = loc.Location();
  MapController mapController = MapController();

  void getCurrentLocation() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData? locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print("Not enabled");
        }else {
          if (kDebugMode) {
            print("Enabled");
          }
        }
        // Location services are not enabled
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        if (kDebugMode) {
          print("Not Granted");
        }
        // Location permissions are not granted
        return;
      }
    }

    locationData = await location.getLocation();
    double? latitude = locationData.latitude;
    double? longitude = locationData.longitude;

    setState(() {
      _currentPosition = latitude != null && longitude != null
          ? LatLng(
              latitude,
              longitude,
            )
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          options: MapOptions(
            center: _currentPosition ?? LatLng(1, 1),
            zoom: 9.2,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/btwitsmiky/clhib20g601h701qy1m7vdmw7/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYnR3aXRzbWlreSIsImEiOiJjbGhpYXE4NHQwNjJwM2VtdWlhbXIzaDk4In0.VSGgUeeg9wY4gVNkCcLSUw',
              additionalOptions: const {
                'accessToken':
                    'pk.eyJ1IjoiYnR3aXRzbWlreSIsImEiOiJjbGhpYXE4NHQwNjJwM2VtdWlhbXIzaDk4In0.VSGgUeeg9wY4gVNkCcLSUw',
                'id': 'mapbox.mapbox-streets-v8'
              },
            ),
            MarkerLayer(
              markers: _currentPosition != null
                  ? [
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentPosition!,
                        builder: (ctx) => const Icon(
                          Icons.location_on,
                          size: 50.0,
                          color: Colors.red,
                        ),
                      ),
                    ]
                  : [],
            ),
            FloatingActionButton(
              onPressed: getCurrentLocation,
              child: const Text("G L"),),
          ],
        ),
      ),
    );
  }
}
