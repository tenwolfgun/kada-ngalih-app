import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NearbyLocationEvent extends Equatable {
  const NearbyLocationEvent();
}

class GetNearbyLocationEvent extends NearbyLocationEvent {
  final String distance;
  final String lat;
  final String lng;

  const GetNearbyLocationEvent({
    @required this.distance,
    @required this.lat,
    @required this.lng,
  });

  @override
  List<Object> get props => [distance, lat, lng];
}

class RefreshNearbyLocation extends NearbyLocationEvent {
  final String distance;
  final String lat;
  final String lng;

  const RefreshNearbyLocation({
    @required this.distance,
    @required this.lat,
    @required this.lng,
  });

  @override
  List<Object> get props => null;
}
