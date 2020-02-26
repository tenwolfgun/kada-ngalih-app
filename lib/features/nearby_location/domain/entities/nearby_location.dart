import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'datum.dart';

class NearbyLocation extends Equatable {
  final List<Datum> data;
  final String status;

  NearbyLocation({@required this.data, @required this.status});

  NearbyLocation copyWith({
    Datum data,
    String status,
  }) =>
      NearbyLocation(data: data ?? this.data, status: status ?? this.status);

  @override
  List<Object> get props => [data, status];
}
