import 'package:permission_handler/permission_handler.dart';

abstract class DeviceLocation {
  Future<PermissionStatus> get isGranted;
  Future<ServiceStatus> get isDisabled;
}

class DeviceLocationImpl implements DeviceLocation {
  final PermissionHandler permissionHandler;

  DeviceLocationImpl(this.permissionHandler);

  @override
  Future<ServiceStatus> get isDisabled =>
      permissionHandler.checkServiceStatus(PermissionGroup.location);

  @override
  Future<PermissionStatus> get isGranted =>
      permissionHandler.checkPermissionStatus(PermissionGroup.location);
}
