import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'category.dart';

class Datum extends Equatable {
  final int id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String image;
  final String source;
  final Category category;
  final double distance;

  Datum({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.lat,
    @required this.lng,
    @required this.image,
    @required this.source,
    @required this.category,
    @required this.distance,
  });

  @override
  List<Object> get props => [
        id,
        name,
        address,
        lat,
        lng,
        image,
        source,
        category,
        distance,
      ];
}
