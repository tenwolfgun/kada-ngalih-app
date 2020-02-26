import 'package:kada_ngalih/features/nearby_location/domain/entities/category.dart';

import '../../domain/entities/datum.dart';
import 'package:meta/meta.dart';

import 'category_model.dart';

class DatumModel extends Datum {
  DatumModel({
    @required int id,
    @required String name,
    @required String address,
    @required double lat,
    @required double lng,
    @required String image,
    @required Category category,
    @required double distance,
    @required String source,
  }) : super(
          id: id,
          name: name,
          address: address,
          lat: lat,
          lng: lng,
          image: image,
          category: category,
          distance: distance,
          source: source,
        );

  factory DatumModel.fromJson(Map<String, dynamic> json) => DatumModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        address: json["address"] == null ? null : json["address"],
        lat: json["lat"] == null ? null : json["lat"],
        lng: json["lng"] == null ? null : json["lng"],
        image: json["image"] == null ? null : json["image"],
        category: json["category"] == null
            ? null
            : CategoryModel.fromJson(json["category"]),
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        source: json["source"] == null ? null : json["source"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "name": name ?? null,
        "address": address ?? null,
        "lat": lat ?? null,
        "lng": lng ?? null,
        "image": image ?? null,
        "category": category ?? null,
        "distance": distance ?? null,
      };
}
