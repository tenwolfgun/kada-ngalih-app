import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/core/error/exceptions.dart';
import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/core/platform/device_location.dart';
import 'package:kada_ngalih/features/nearby_location/data/datasources/nearby_location_remote_data_source.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:kada_ngalih/features/nearby_location/domain/repositories/nearby_location_repository.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyLocationRepositoryImpl implements NearbyLocationRepository {
  final NearbyLocationRemoteDataSource remoteDataSource;
  final DeviceLocation deviceLocation;

  NearbyLocationRepositoryImpl(
      {@required this.remoteDataSource, @required this.deviceLocation});

  @override
  Future<Either<Failures, NearbyLocation>> getNearbyLocation({
    @required int distance,
    @required double lat,
    @required double lng,
  }) async {
    if (await deviceLocation.isGranted == PermissionStatus.denied) {
      return Left(PermissionFailure());
    } else if (await deviceLocation.isDisabled == ServiceStatus.disabled) {
      return Left(GetLocationFailure());
    } else {
      try {
        final result = await remoteDataSource.getNearbyLocation(
          distance: distance,
          lat: lat,
          lng: lng,
        );

        if (result.data.isEmpty) {
          return Left(NoResultFailures());
        }

        return Right(result);
      } on ServerException catch (_) {
        return Left(ServerFailure());
      } on ConnectionException catch (_) {
        return Left(ConnectionFailure());
      }
    }
  }
}
