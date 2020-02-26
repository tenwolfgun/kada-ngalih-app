import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:kada_ngalih/core/error/failures.dart';
import 'package:kada_ngalih/core/util/input_converter.dart';
import 'package:kada_ngalih/features/nearby_location/domain/usecases/get_nearby_location.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = "Tidak dapat mengambil data dari server";
const String INVALID_INPUT_MESSAGE = "Input yang anda masukan salah";
const String PERMISSION_FAILURE_MESSAGE =
    "Aplikasi ini membutuhkan izin lokasi";
const String GET_LOCATION_FAILURE_MESSAGE =
    "Tidak dapat mendapatkan lokasi pengguna";
const String NO_RESULT_FAILURE_MESSAGE =
    "Data belum tersedia untuk daerah anda";
const String CONNECTION_FAILURE_MESSAGE =
    "Tidak dapat tersambung ke server, silahkan periksa koneksi internet anda";

class NearbyLocationBloc
    extends Bloc<NearbyLocationEvent, NearbyLocationState> {
  final GetNearbyLocation getNearbyLocation;
  final InputConverter inputConverter;

  NearbyLocationBloc({
    @required this.getNearbyLocation,
    @required this.inputConverter,
  })  : assert(getNearbyLocation != null),
        assert(inputConverter != null);

  @override
  NearbyLocationState get initialState => InitialNearbyLocationState();

  @override
  Stream<NearbyLocationState> mapEventToState(
    NearbyLocationEvent event,
  ) async* {
    if (event is GetNearbyLocationEvent) {
      yield LoadingState();
      final inputDistance = inputConverter.stringToUnsignedInteger(
        event.distance,
      );
      final inputLat = inputConverter.stringToDouble(event.lat);
      final inputLng = inputConverter.stringToDouble(event.lng);

      yield* mapGetNearbyLocation(inputDistance, inputLat, inputLng);
    } else if (event is RefreshNearbyLocation) {
      yield LoadingState();
      final inputDistance = inputConverter.stringToUnsignedInteger(
        event.distance,
      );
      final inputLat = inputConverter.stringToDouble(event.lat);
      final inputLng = inputConverter.stringToDouble(event.lng);

      yield* mapRefreshNearbyLocation(inputDistance, inputLat, inputLng);
    }
  }

  Stream<NearbyLocationState> mapGetNearbyLocation(
    Either<Failures, int> inputDistance,
    Either<Failures, double> inputLat,
    Either<Failures, double> inputLng,
  ) async* {
    int _convertedDistance;
    double _convertedLat;
    double _convertedLng;
    yield* inputDistance.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedDistance = success;
      },
    );

    yield* inputLat.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedLat = success;
      },
    );
    yield* inputLng.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedLng = success;
      },
    );

    final result = await getNearbyLocation(
      distance: _convertedDistance,
      lat: _convertedLat,
      lng: _convertedLng,
    );

    yield result.fold(
      (failure) => ErrorState(errorMessage: _mapFailureToMesssage(failure)),
      (location) => LoadedState(location),
    );
  }

  Stream<NearbyLocationState> mapRefreshNearbyLocation(
    Either<Failures, int> inputDistance,
    Either<Failures, double> inputLat,
    Either<Failures, double> inputLng,
  ) async* {
    int _convertedDistance;
    double _convertedLat;
    double _convertedLng;
    yield* inputDistance.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedDistance = success;
      },
    );

    yield* inputLat.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedLat = success;
      },
    );
    yield* inputLng.fold(
      (failure) async* {
        yield ErrorState(errorMessage: INVALID_INPUT_MESSAGE);
      },
      (success) async* {
        _convertedLng = success;
      },
    );

    final result = await getNearbyLocation(
      distance: _convertedDistance,
      lat: _convertedLat,
      lng: _convertedLng,
    );

    yield result.fold(
      (failure) => ErrorState(errorMessage: _mapFailureToMesssage(failure)),
      (location) => LoadedState(location),
    );
  }

  String _mapFailureToMesssage(Failures failures) {
    switch (failures.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case InvalidInputFailure:
        return INVALID_INPUT_MESSAGE;
      case PermissionFailure:
        return PERMISSION_FAILURE_MESSAGE;
      case GetLocationFailure:
        return GET_LOCATION_FAILURE_MESSAGE;
        break;
      case NoResultFailures:
        return NO_RESULT_FAILURE_MESSAGE;
        break;
      case ConnectionFailure:
        return CONNECTION_FAILURE_MESSAGE;
        break;
      default:
        return 'Unexpected Error';
    }
  }
}
