import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Category extends Equatable {
  final int id;
  final String name;

  Category({
    @required this.id,
    @required this.name,
  });

  @override
  List<Object> get props => [id, name];
}
