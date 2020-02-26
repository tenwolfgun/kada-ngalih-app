import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:meta/meta.dart';

import '../repositories/nearby_location_repository.dart';

class GetNearbyLocation {
  final NearbyLocationRepository repository;

  GetNearbyLocation(this.repository);

  Future<Either<Failures, NearbyLocation>> call({
    @required int distance,
    @required double lat,
    @required double lng,
  }) async {
    return await repository.getNearbyLocation(
      distance: distance,
      lat: lat,
      lng: lng,
    );
  }
}
