class _MapScreenState extends State<MapScreen> {
  YandexMapController? _yaMapController;
  static const Point _startPoint = Point(latitude: 50, longitude: 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ваша карта'),
      ),
      body: YandexMap(
        onMapCreated: (YandexMapController controller) async {
          _yaMapController = controller;
          await _yaMapController!.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _startPoint,
                zoom: 10,
              ),
            ),
            animation: const MapAnimation(
              type: MapAnimationType.smooth,
              duration: 2.0,
            ),
          );
        },
        onUserLocationAdded: (UserLocationView view) async {
          return view.copyWith(
            pin: view.pin.copyWith(
              isVisible: true,
              point: _startPoint,
              opacity: 0.99,
              icon: await PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromAssetImage(
                      'assets/location_icon.png'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
