import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bemagro_weather/globals/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double long;
  const MapScreen({super.key, required this.lat, required this.long});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();

  MapType mapType = MapType.normal;

  List<MapType> mapTypes = [
    MapType.normal,
    MapType.hybrid,
    MapType.satellite,
    MapType.terrain,
  ];

  final List<bool> selectedMapType = <bool>[true, false, false, false];

  String buttonLabel = 'ZOOM NA LOCALIZAÇÃO';
  double zoomLevel = 15;

  IconButton btChangeMapVisualization() {
    return IconButton(
      onPressed: () async {
        MapType? mt = await showMapTypePicker(context, types: mapTypes);
        if (mt != null) {
          setState(() {
            mapType = mt;
          });
        }
      },
      icon: Icon(
        Icons.settings_outlined,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'HEARTBEAT MAP VIEW',
          style: TextStyle(
            fontFamily: 'Nothing',
            fontSize: 15,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [btChangeMapVisualization()],
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: mapType,
            markers: {
              Marker(
                markerId: const MarkerId('closestCityLatLongMarker'),
                position: LatLng(widget.lat, widget.long),
                draggable: false,
              ),
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.lat, widget.long),
              zoom: zoomLevel,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController.complete(controller);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: zoom,
        label: AutoSizeText(buttonLabel),
        icon: const Icon(Icons.zoom_in_map_outlined),
        backgroundColor: Colors.red[300],
      ),
    );
  }

  Future<void> initializeMap() async {
    final GoogleMapController controller = await mapController.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.lat, widget.long),
          zoom: zoomLevel,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initializeMap());
  }

  Widget mapTypePickerBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.adaptive.arrow_back_outlined, size: 30),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: mapTypes.length,
            itemBuilder: (context, index) {
              return ListTile(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                title: Center(
                    child: AutoSizeText(mapTypes[index].name.capitalize())),
                onTap: () {
                  Navigator.pop(context, mapTypes[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<MapType?> showMapTypePicker(
    BuildContext context, {
    required List<MapType> types,
  }) async {
    return await showModalBottomSheet<MapType>(
      isDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return mapTypePickerBody();
      },
    );
  }

  Future<void> zoom() async {
    final GoogleMapController controller = await mapController.future;

    if (zoomLevel == 20) {
      buttonLabel = 'ZOOM NA LOCALIZAÇÃO';
      zoomLevel = 15;
    } else {
      buttonLabel = 'DESFAZER ZOOM';
      zoomLevel = 20;
    }
    setState(() {});

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.lat, widget.long),
          bearing: 190,
          tilt: 60,
          zoom: zoomLevel,
        ),
      ),
    );
  }
}
