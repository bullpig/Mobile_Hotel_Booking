import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/directions_repository.dart';
import 'package:hotel_booking/models/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:location/location.dart';

import 'hotelDetails.dart';

class MapScreen extends StatefulWidget {
  Marker? destination;
  List<Marker>? listHotelMarker;
  String? destinationFocus;
  int dem = 0;

  MapScreen();
  MapScreen.fromDestination(
      GeoPoint _destinaton, String hotelId, String hotelName) {
    destinationFocus = hotelId;
    this.destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: InfoWindow(title: hotelName),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(_destinaton.latitude, _destinaton.longitude),
    );
  }

  MapScreen.fromListHotel(var _listHotel) {
    listHotelMarker = _listHotel
        .map<Marker>((value) => Marker(
            markerId: MarkerId(value.id),
            infoWindow: InfoWindow(title: value.name),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(value.location.latitude, value.location.longitude),
            onTap: () {
              destinationFocus = value.id;
            }))
        .toList();

    print(listHotelMarker.toString());
  }

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData userLocation =
      LocationData.fromMap({'latitude': 21.0413, 'longitude': 105.7871});
  late GoogleMapController _googleMapController;
  Marker? _origin = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: const InfoWindow(title: 'Origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    position: LatLng(21.0413, 105.7871),
  );
  Marker? _locationMarker;
  Location currentLocation = Location();
  Directions? _info;

  Future<void> getLocation() async {
    print("kk");
    var location = await currentLocation.getLocation();
    currentLocation.onLocationChanged.listen((LocationData loc) {
      if (loc.latitude != userLocation.latitude ||
          loc.longitude != userLocation.longitude ||
          userLocation.latitude == null ||
          userLocation.longitude == null) {
        if (this.mounted) {
          setState(() {
            userLocation = loc;
            _origin = Marker(
              markerId: const MarkerId('Location'),
              infoWindow: const InfoWindow(title: 'Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: LatLng(loc.latitude!, loc.longitude!),
            );
            // _origin = _locationMarker;
          });
          print(_origin?.position.latitude);
          print(_origin?.position.longitude);
        }
      }
    });
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    setState(() {
      widget.destinationFocus = widget.destinationFocus;
      widget.listHotelMarker = widget.listHotelMarker;
    });
    print(widget.destinationFocus);
    print(e);
  }

  Future<void> getDestinationHotel() async {
    if (widget.destination != null) {
      var directions = await DirectionsRepository().getDirections(
          origin: _origin!.position, destination: widget.destination!.position);
      setState(() => _info = directions!);

      print(_info.toString());
    }
  }

  void buildData() async {
    await getLocation();
    await getDestinationHotel();
  }

  @override
  Widget build(BuildContext context) {
    buildData();
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            iconSize: 30.0,
            color: Colors.blue,
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Text(
            'Bản Đồ',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            if (_origin != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _origin!.position,
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.green,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('ORIGIN'),
              ),
            if (widget.destination != null)
              TextButton(
                onPressed: () => _googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: widget.destination?.position ?? LatLng(1, 1),
                      zoom: 14.5,
                      tilt: 50.0,
                    ),
                  ),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                child: const Text('DEST'),
              )
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _origin!.position.latitude, _origin!.position.longitude),
                zoom: 12,
              ),
              onMapCreated: (controller) => _googleMapController = controller,
              markers: {
                if (_origin != null) _origin!,
                if (widget.destination != null) widget.destination!,
                if (_locationMarker != null) _locationMarker!,
                if (widget.listHotelMarker != null) ...widget.listHotelMarker!,
              },
              polylines: {
                if (_info != null)
                  Polyline(
                    polylineId: const PolylineId('overview_polyline'),
                    color: Colors.lightBlue,
                    width: 5,
                    points: _info!.polylinePoints
                        .map((e) => LatLng(e.latitude, e.longitude))
                        .toList(),
                  ),
              },

              // onLongPress: _addMarker,
            ),
            if (_info != null)
              Positioned(
                top: 20.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    '${_info?.totalDistance}, ${_info?.totalDuration}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () {
                if (widget.destinationFocus != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HotelDetail(
                        hotelId: widget.destinationFocus!,
                      ),
                    ),
                  ).then((value) => setState(() {}));
                }
              },
              child: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () => _googleMapController.animateCamera(
                _info != null
                    ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(userLocation.latitude ?? 0.0,
                            userLocation.longitude ?? 0.0),
                        zoom: 11.5,
                      )),
              ),
              child: const Icon(Icons.center_focus_strong),
            ),
            SizedBox(height: 50),
          ],
        ));
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && widget.destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        widget.destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        widget.destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      var directions = await DirectionsRepository()
          .getDirections(origin: _origin!.position, destination: pos);
      setState(() => _info = directions!);
    }
  }
}
