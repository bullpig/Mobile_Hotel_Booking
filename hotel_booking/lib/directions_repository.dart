import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hotel_booking/directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotel_booking/models/directions_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository() : _dio = Dio();
  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': 'AIzaSyDRTqdwJNinnipAYcH9w269mediWUWdnJ4',
      },
    );

    // Check if response is successful
    print("1111111111111111111111111111111111111111111111111111111");
    if (response.statusCode == 200) {
      print(response.data.toString());

      return Directions.fromMap(response.data);
    }
    return null;
  }
}
