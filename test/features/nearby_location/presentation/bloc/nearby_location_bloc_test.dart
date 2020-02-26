import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/core/util/input_converter.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/datum.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:kada_ngalih/features/nearby_location/domain/usecases/get_nearby_location.dart';
import 'package:kada_ngalih/features/nearby_location/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetNearbyLocation extends Mock implements GetNearbyLocation {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NearbyLocationBloc bloc;
  MockGetNearbyLocation mockGetNearbyLocation;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetNearbyLocation = MockGetNearbyLocation();
    mockInputConverter = MockInputConverter();
    bloc = NearbyLocationBloc(
        getNearbyLocation: mockGetNearbyLocation,
        inputConverter: mockInputConverter);
  });

  test('InitialState should be InitialNearbyLocationState', () {
    expect(bloc.initialState, equals(InitialNearbyLocationState()));
  });

  group('getNearbyLocation', () {
    final tDistance = "2";
    final tDistanceParsed = 2;
    final tLat = "-3.2323";
    final tLatParsed = -3.2323;
    final tLng = "144.3232";
    final tLngParsed = 144.3232;

    final tNearbyLocation =
        NearbyLocation(data: List<Datum>(), status: "berhasil");

    test(
      'should call input converter to validate and convert the string to int or double',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(tDistance))
            .thenReturn(Right(tDistanceParsed));
        when(mockInputConverter.stringToDouble(tLat))
            .thenReturn(Right(tLatParsed));
        when(mockInputConverter.stringToDouble(tLng))
            .thenReturn(Right(tLngParsed));

        bloc.add(GetNearbyLocationEvent(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        ));

        await untilCalled(
            mockInputConverter.stringToUnsignedInteger(tDistance));

        await untilCalled(mockInputConverter.stringToDouble(tLat));

        await untilCalled(mockInputConverter.stringToDouble(tLng));

        verify(mockInputConverter.stringToUnsignedInteger(tDistance));
        verify(mockInputConverter.stringToDouble(tLat));
        verify(mockInputConverter.stringToDouble(tLng));
      },
    );

    test(
      'should emit [ErrorState] when the input is invalid',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(tDistance))
            .thenReturn(Left(InvalidInputFailure()));
        when(mockInputConverter.stringToDouble(tLat))
            .thenReturn(Left(InvalidInputFailure()));
        when(mockInputConverter.stringToDouble(tLng))
            .thenReturn(Left(InvalidInputFailure()));

        final expected = [
          InitialNearbyLocationState(),
          LoadingState(),
          ErrorState(errorMessage: INVALID_INPUT_MESSAGE),
        ];

        expectLater(bloc.cast(), emitsInOrder(expected));

        bloc.add(GetNearbyLocationEvent(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        ));
      },
    );

    test(
      'should get data',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(tDistance))
            .thenReturn(Right(tDistanceParsed));
        when(mockInputConverter.stringToDouble(tLat))
            .thenReturn(Right(tLatParsed));
        when(mockInputConverter.stringToDouble(tLng))
            .thenReturn(Right(tLngParsed));
        when(mockGetNearbyLocation(
          distance: anyNamed("distance"),
          lat: anyNamed("lat"),
          lng: anyNamed("lng"),
        )).thenAnswer((_) async => Right(tNearbyLocation));

        bloc.add(GetNearbyLocationEvent(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        ));

        await untilCalled(mockGetNearbyLocation(
          distance: anyNamed("distance"),
          lat: anyNamed("lat"),
          lng: anyNamed("lng"),
        ));

        verify(mockGetNearbyLocation(
          distance: tDistanceParsed,
          lat: tLatParsed,
          lng: tLngParsed,
        ));
      },
    );

    test(
      'should emit [loading, loaded]',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(tDistance))
            .thenReturn(Right(tDistanceParsed));
        when(mockInputConverter.stringToDouble(tLat))
            .thenReturn(Right(tLatParsed));
        when(mockInputConverter.stringToDouble(tLng))
            .thenReturn(Right(tLngParsed));
        when(mockGetNearbyLocation(
          distance: anyNamed("distance"),
          lat: anyNamed("lat"),
          lng: anyNamed("lng"),
        )).thenAnswer((_) async => Right(tNearbyLocation));

        final expected = [
          InitialNearbyLocationState(),
          LoadingState(),
          LoadedState(tNearbyLocation),
        ];

        expectLater(bloc.cast(), emitsInOrder(expected));

        bloc.add(GetNearbyLocationEvent(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        ));
      },
    );

    test(
      'should emit [Loading, Error]',
      () async {
        when(mockInputConverter.stringToUnsignedInteger(tDistance))
            .thenReturn(Right(tDistanceParsed));
        when(mockInputConverter.stringToDouble(tLat))
            .thenReturn(Right(tLatParsed));
        when(mockInputConverter.stringToDouble(tLng))
            .thenReturn(Right(tLngParsed));
        when(mockGetNearbyLocation(
          distance: anyNamed("distance"),
          lat: anyNamed("lat"),
          lng: anyNamed("lng"),
        )).thenAnswer((_) async => Left(ServerFailure()));

        final expected = [
          InitialNearbyLocationState(),
          LoadingState(),
          ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc.cast(), emitsInOrder(expected));

        bloc.add(GetNearbyLocationEvent(
          distance: tDistance,
          lat: tLat,
          lng: tLng,
        ));
      },
    );
  });
}
