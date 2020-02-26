import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  const Failures();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failures {}

class PermissionFailure extends Failures {}

class GetLocationFailure extends Failures {}

class ConnectionFailure extends Failures {}

class NoResultFailures extends Failures {}
