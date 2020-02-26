import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/core/error/exceptions.dart';
import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/core/platform/device_location.dart';
import 'package:kada_ngalih/features/nearby_location/data/datasources/nearby_location_remote_data_source.dart';
import 'package:kada_ngalih/features/nearby_location/data/models/nearby_location_model.dart';
import 'package:kada_ngalih/features/nearby_location/data/repositories/nearby_location_repository_impl.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockRemoteDataSource extends Mock
    implements NearbyLocationRemoteDataSource {}

class MockLocationPermission extends Mock implements DeviceLocation {}

void main() {
  NearbyLocationRepositoryImpl nearbyLocationRepositoryImpl;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocationPermission mockLocationPermission;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocationPermission = MockLocationPermission();
    nearbyLocationRepositoryImpl = NearbyLocationRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      deviceLocation: mockLocationPermission,
    );
  });

  group('getNearbyLocation', () {
    final tDistance = 2;
    final tLat = -3.12323;
    final tLng = 144.12321;
    final tNearbyLocationModel =
        nearbyLocationModelFromJson(fixture("nearby_location.json"));
    final NearbyLocation tNearbyLocation = tNearbyLocationModel;
    test(
      'should check if permission is granted',
      () async {
        when(mockLocationPermission.isGranted)
            .thenAnswer((_) async => PermissionStatus.granted);
        when(mockRemoteDataSource.getNearbyLocation(
          distance: anyNamed("distance"),
          lat: anyNamed("lat"),
          lng: anyNamed("lng"),
        )).thenAnswer((_) async => tNearbyLocationModel);
        nearbyLocationRepositoryImpl.getNearbyLocation(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        );
        verify(mockLocationPermission.isGranted);
      },
    );

    group('permission granted', () {
      setUp(() {
        when(mockLocationPermission.isGranted)
            .thenAnswer((_) async => PermissionStatus.granted);
      });

      test(
        'should return remote data',
        () async {
          when(mockRemoteDataSource.getNearbyLocation(
            distance: anyNamed("distance"),
            lat: anyNamed("lat"),
            lng: anyNamed("lng"),
          )).thenAnswer((_) async => tNearbyLocationModel);
          final result = await nearbyLocationRepositoryImpl.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          );
          verify(mockRemoteDataSource.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          ));
          expect(result, equals(Right(tNearbyLocation)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessfull',
        () async {
          when(mockRemoteDataSource.getNearbyLocation(
            distance: anyNamed("distance"),
            lat: anyNamed("lat"),
            lng: anyNamed("lng"),
          )).thenThrow((ServerException("Cannot get data from server")));

          final result = await nearbyLocationRepositoryImpl.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          );

          verify(mockRemoteDataSource.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          ));

          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    group('permission denied', () {
      setUp(() {
        when(mockLocationPermission.isGranted)
            .thenAnswer((_) async => PermissionStatus.denied);
      });

      test(
        'should return permission failure when location permission denied',
        () async {
          // when(mockRemoteDataSource.getNearbyLocation(
          //   distance: anyNamed("distance"),
          //   lat: anyNamed("lat"),
          //   lng: anyNamed("lng"),
          // )).thenThrow((PermissionDeniedException(
          //     "Aplikasi ini membutuhkan ijin lokasi")));

          final result = await nearbyLocationRepositoryImpl.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          );

          // verify(mockRemoteDataSource.getNearbyLocation(
          //   distance: tDistance,
          //   lat: tLat,
          //   lng: tLng,
          // ));

          expect(result, equals(Left(PermissionFailure())));
        },
      );
    });

    group('location not active', () {
      setUp(() {
        when(mockLocationPermission.isDisabled)
            .thenAnswer((_) async => ServiceStatus.disabled);
      });

      test(
        'should return get location failure when cannot get device location',
        () async {
          // when(mockRemoteDataSource.getNearbyLocation(
          //   distance: anyNamed("distance"),
          //   lat: anyNamed("lat"),
          //   lng: anyNamed("lng"),
          // )).thenThrow((PermissionDeniedException(
          //     "Aplikasi ini membutuhkan ijin lokasi")));

          final result = await nearbyLocationRepositoryImpl.getNearbyLocation(
            distance: tDistance,
            lat: tLat,
            lng: tLng,
          );

          // verify(mockRemoteDataSource.getNearbyLocation(
          //   distance: tDistance,
          //   lat: tLat,
          //   lng: tLng,
          // ));

          expect(result, equals(Left(GetLocationFailure())));
        },
      );
    });
  });
}
