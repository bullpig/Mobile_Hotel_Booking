import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/api_controller.dart';
import 'package:hotel_booking/directions_repository.dart';
import 'package:hotel_booking/models/directions_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_booking/models/hotel_model.dart';
import 'package:location/location.dart';

// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Google Maps',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: Colors.white,
//       ),
//       home: _MapScreen(),
//     );
//   }
// }

class MapScreen extends StatefulWidget {
  Marker? destination;
  List<Hotel>? listHotel;
  Set<Marker>? listHotelMarker;
  MapScreen();
  MapScreen.fromDestination(GeoPoint _destinaton) {
    this.destination = Marker(
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: 'Destination'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: LatLng(_destinaton.latitude, _destinaton.longitude),
    );
  }
  MapScreen.fromListHotel(List<Hotel> _listHotel) {
    this.listHotel = _listHotel;
    listHotelMarker = _listHotel
        .map((e) => Marker(
              markerId: const MarkerId('destination'),
              infoWindow: InfoWindow(title: e.name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              position: LatLng(e.location.latitude, e.location.longitude),
            ))
        .toSet();
  }

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData userLocation =
      LocationData.fromMap({'latitude': 21.02347, 'longitude': 105.7732617});
  late GoogleMapController _googleMapController;
  Marker? _origin = Marker(
    markerId: const MarkerId('origin'),
    infoWindow: const InfoWindow(title: 'Origin'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    position: LatLng(21.02347, 105.7732617),
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
                  BitmapDescriptor.hueRed),
              position: LatLng(loc.latitude!, loc.longitude!),
            );
            // _origin = _locationMarker;
          });
          print(_origin?.position.latitude);
          print(_origin?.position.longitude);
          // print(userLocation.latitude);
          // print(userLocation.longitude);
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
    buildData();
  }

  Future<void> getDestinationHotel() async {
    print("eee");
    if (widget.destination != null) {
      var directions = await DirectionsRepository().getDirections(
          origin: _origin!.position, destination: widget.destination!.position);
      setState(() => _info = directions!);
      print(_info.toString());
    }
  }

  void buildData() async {
    print(1);
    getLocation();
    print(2);
    getDestinationHotel();
    print(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  color: Colors.red,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
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
    );
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
