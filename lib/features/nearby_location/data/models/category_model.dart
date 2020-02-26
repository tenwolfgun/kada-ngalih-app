import 'package:kada_ngalih/features/nearby_location/domain/entities/category.dart';
import 'package:meta/meta.dart';

class CategoryModel extends Category {
  CategoryModel({
    @required int id,
    @required String name,
  }) : super(id: id, name: name);

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? null,
        "name": name ?? null,
      };
}
