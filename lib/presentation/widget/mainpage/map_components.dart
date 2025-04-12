import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:multimedia_apps/core/extension/extension.dart';

class MapsComponent extends StatefulWidget {
  final MapsType mapsType;

  const MapsComponent({super.key, this.mapsType = MapsType.largeSize});

  @override
  State<MapsComponent> createState() => _MapsState();
}

class _MapsState extends State<MapsComponent> {
  final MapController mapController = MapController();
  final double _initialCameraZoom = 15;
  @override
  Widget build(BuildContext context) {
    late double sizeWidth;
    late double sizeHeight;

    if (widget.mapsType == MapsType.smallSize) {
      sizeWidth = double.infinity;
      sizeHeight = 400.h;
    } else {
      sizeWidth = double.infinity;
      sizeHeight = context.deviceHeight;
    }

    return SizedBox(
        width: sizeWidth,
        height: sizeHeight,
        child: Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    initialCenter: const LatLng(-6.595038, 106.816635),
                    initialZoom: _initialCameraZoom,
                    cameraConstraint: CameraConstraint.contain(
                        bounds:
                            LatLngBounds(LatLng(-90, -180), LatLng(90, 180)))),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    tileProvider: CancellableNetworkTileProvider(),
                    subdomains: const ['a', 'b', 'c'],
                    maxZoom: 19,
                  ),
                  CurrentLocationLayer(
                    alignDirectionOnUpdate: AlignOnUpdate.always,
                    style: const LocationMarkerStyle(
                      marker: DefaultLocationMarker(
                        // color: Colors.blue,
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                      ),
                      markerSize: Size(40, 40),
                      markerDirection: MarkerDirection.heading,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                bottom: 40,
                right: 40,
                child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: const Icon(
                      Icons.location_on_outlined,
                      size: 35,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Geolocator.getCurrentPosition().then((location) {
                        mapController.move(
                            LatLng(location.latitude, location.longitude),
                            _initialCameraZoom);
                        setState(() {});
                      });
                    }))
          ],
        ));
  }
}

enum MapsType {
  largeSize,
  smallSize,
}
