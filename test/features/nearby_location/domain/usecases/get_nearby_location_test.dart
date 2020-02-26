import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/datum.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:kada_ngalih/features/nearby_location/domain/repositories/nearby_location_repository.dart';
import 'package:kada_ngalih/features/nearby_location/domain/usecases/get_nearby_location.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNearbyLocationRepository extends Mock
    implements NearbyLocationRepository {}

void main() {
  GetNearbyLocation getNearbyLocation;
  MockNearbyLocationRepository mockNearbyLocationRepository;
  setUp(() {
    mockNearbyLocationRepository = MockNearbyLocationRepository();
    getNearbyLocation = GetNearbyLocation(mockNearbyLocationRepository);
  });

  final tNearbyLocation = NearbyLocation(data: List<Datum>(), status: "sukses");

  final tDistance = 2;
  final tLat = -31.2323;
  final tLng = 144.32323;

  test(
    'should get nearby location entity from the repository',
    () async {
      when(mockNearbyLocationRepository.getNearbyLocation(
        distance: anyNamed("distance"),
        lat: anyNamed("lat"),
        lng: anyNamed("lng"),
      )).thenAnswer((_) async => Right(tNearbyLocation));

      final result = await getNearbyLocation(
        distance: tDistance,
        lat: tLat,
        lng: tLng,
      );

      expect(result, Right(tNearbyLocation));
      verify(mockNearbyLocationRepository.getNearbyLocation(
        distance: tDistance,
        lat: tLat,
        lng: tLng,
      ));
      verifyNoMoreInteractions(mockNearbyLocationRepository);
    },
  );
}
