import 'dart:convert';

import 'package:meta/meta.dart';

import '../../domain/entities/datum.dart';
import '../../domain/entities/nearby_location.dart';
import 'datum_model.dart';

NearbyLocationModel nearbyLocationModelFromJson(String str) =>
    NearbyLocationModel.fromJson(json.decode(str));

String nearbyLocationModelToJson(NearbyLocationModel data) =>
    json.encode(data.toJson());

class NearbyLocationModel extends NearbyLocation {
  NearbyLocationModel({
    @required List<Datum> data,
    @required String status,
  }) : super(data: data, status: status);

  factory NearbyLocationModel.fromJson(Map<String, dynamic> json) =>
      NearbyLocationModel(
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => DatumModel.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() {
    return {
      'data': data ?? null,
      'status': status ?? null,
    };
  }
}
