import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:meta/meta.dart';

abstract class NearbyLocationRepository {
  Future<Either<Failures, NearbyLocation>> getNearbyLocation({
    @required int distance,
    @required double lat,
    @required double lng,
  });
}
