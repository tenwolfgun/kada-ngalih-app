import 'package:equatable/equatable.dart';
import 'package:kada_ngalih/features/nearby_location/domain/entities/nearby_location.dart';
import 'package:meta/meta.dart';

abstract class NearbyLocationState extends Equatable {
  const NearbyLocationState();
}

class InitialNearbyLocationState extends NearbyLocationState {
  @override
  List<Object> get props => [];
}

class LoadingState extends NearbyLocationState {
  @override
  List<Object> get props => [];
}

class LoadedState extends NearbyLocationState {
  final NearbyLocation nearbyLocation;

  const LoadedState(this.nearbyLocation);

  @override
  List<Object> get props => [nearbyLocation];
}

class ErrorState extends NearbyLocationState {
  final String errorMessage;

  ErrorState({@required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
