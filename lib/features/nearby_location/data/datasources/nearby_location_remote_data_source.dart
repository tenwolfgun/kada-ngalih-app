import 'dart:io';

import 'package:kada_ngalih/core/error/exceptions.dart';
import 'package:kada_ngalih/features/nearby_location/data/models/nearby_location_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

abstract class NearbyLocationRemoteDataSource {
  /// Throws a [Server Exception] for all error code
  Future<NearbyLocationModel> getNearbyLocation({
    @required int distance,
    @required double lat,
    @required double lng,
  });
}

class NearbyLocationRemoteDataSourceImpl
    implements NearbyLocationRemoteDataSource {
  final http.Client client;

  NearbyLocationRemoteDataSourceImpl({@required this.client});

  @override
  Future<NearbyLocationModel> getNearbyLocation({
    @required int distance,
    @required double lat,
    @required double lng,
  }) async {
    try {
      final response = await client.get('url');

      if (response.statusCode == 200) {
        return nearbyLocationModelFromJson(response.body);
      } else {
        throw ServerException("Tidak dapat mengambil data dari server");
      }
    } on SocketException {
      throw ConnectionException();
    }
  }
}
