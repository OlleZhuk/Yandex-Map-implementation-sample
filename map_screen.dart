// ЭКРАН КАРТЫ
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation = const PlaceLocation(
      latitude: 57.1544,
      longitude: 65.5505,
      address: '',
    ),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];
  final MapObjectId mapObjectId = const MapObjectId('selPoint');
  final animation = MapAnimation(type: MapAnimationType.smooth, duration: 2);
  final placemarkIcon = PlacemarkIcon.single(
    PlacemarkIconStyle(
      image: BitmapDescriptor.fromAssetImage('lib/assets/location_icon.png'),
      scale: 0.25,
    ),
  );
  Point? pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text('Ваша карта'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(pickedLocation);
                    },
            ),
        ],
      ),
      body: YandexMap(
        mapObjects: mapObjects,
        onMapCreated: (YandexMapController yandexMapController) async {
          controller = yandexMapController;
          await controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: Point(
                  latitude: widget.initialLocation.latitude,
                  longitude: widget.initialLocation.longitude,
                ),
                zoom: 17,
              ),
            ),
            animation: animation,
          );
          final placemark = PlacemarkMapObject(
            mapId: mapObjectId,
            point: (await controller.getCameraPosition()).target,
            icon: placemarkIcon,
            opacity: 0.8,
            isDraggable: true,
          );

          setState(() {
            mapObjects.add(placemark);
          });
        },
        onMapTap: (selectedPoint) async {
          print('Было нажатие на точку $selectedPoint'); // для проверки
          final placemark = PlacemarkMapObject(
            mapId: mapObjectId,
            point: (await controller.getCameraPosition()).target,
            icon: placemarkIcon,
            opacity: 0.8,
            isDraggable: true,
          );

          setState(() {
            mapObjects.removeWhere((el) => el.mapId == MapObjectId);
            mapObjects.add(placemark);
            pickedLocation = selectedPoint;
          });
        },
      ),
    );
  }
}
