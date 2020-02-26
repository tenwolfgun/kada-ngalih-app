import 'package:kada_ngalih/core/platform/device_location.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

class MockPermissionHandler extends Mock implements PermissionHandler {}

void main() {
  DeviceLocationImpl deviceLocationImpl;
  MockPermissionHandler mockPermissionHandler;

  setUp(() {
    mockPermissionHandler = MockPermissionHandler();
    deviceLocationImpl = DeviceLocationImpl(mockPermissionHandler);
  });

  group('isGranted', () {
    test('should foward the PermisionStatus.granted', () async {
      final tIsGranted = PermissionStatus.granted;

      when(mockPermissionHandler
              .checkPermissionStatus(PermissionGroup.location))
          .thenAnswer((_) async => tIsGranted);

      final result = await deviceLocationImpl.isGranted;

      verify(mockPermissionHandler
          .checkPermissionStatus(PermissionGroup.location));

      expect(result, tIsGranted);
    });
  });
}
