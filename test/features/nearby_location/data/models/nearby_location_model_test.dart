import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kada_ngalih/features/nearby_location/data/models/nearby_location_model.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNearbyLocationModel = NearbyLocationModel.fromJson(
      json.decode(fixture('nearby_location.json')));

  test(
    'should be a subclass of NearbyLocation entity',
    () async {
      expect(tNearbyLocationModel, isA<NearbyLocation>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model',
      () async {
        // final Map<String, dynamic> jsonMap =
        //     json.decode(fixture('nearby_location.json'));

        final result =
            nearbyLocationModelFromJson(fixture('nearby_location.json'));

        expect(result, tNearbyLocationModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return json map containing proper data',
      () async {
        final result = nearbyLocationModelToJson(tNearbyLocationModel);

        expect(result, json.encode(tNearbyLocationModel));
      },
    );
  });
}
