import 'package:kada_ngalih/core/error/exceptions.dart';
import 'package:kada_ngalih/features/nearby_location/data/datasources/nearby_location_remote_data_source.dart';
import 'package:kada_ngalih/features/nearby_location/data/models/nearby_location_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NearbyLocationRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NearbyLocationRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('GetNearbyLocation', () {
    final tDistance = 2;
    final tLat = -3.23232;
    final tLng = -144.23233;
    final tNearbyLocationModel =
        nearbyLocationModelFromJson(fixture("nearby_location.json"));

    test(
      'should perform get request on a url with distance, lat, and lng being the endpoint',
      () async {
        when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(fixture('nearby_location.json'), 200));

        dataSourceImpl.getNearbyLocation(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        );

        verify(mockHttpClient.get(
          'url',
        ));
      },
    );

    test(
      'should return NearbyLocation when response is 200 (success)',
      () async {
        when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response(fixture('nearby_location.json'), 200));

        final result = await dataSourceImpl.getNearbyLocation(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        );

        expect(result, equals(tNearbyLocationModel));
      },
    );

    test(
      'should throw a ServerException for when the response code is 404 or other',
      () async {
        when(mockHttpClient.get(any)).thenAnswer(
            (_) async => http.Response('Something when wrong', 404));

        final call = dataSourceImpl.getNearbyLocation;

        expect(
            () => call(
                  distance: tDistance,
                  lat: tLat,
                  lng: tLng,
                ),
            throwsA(isInstanceOf<ServerException>()));
      },
    );
  });
}
