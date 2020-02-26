import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/nearby_location/presentation/pages/nearby_location_page.dart';
import 'permission_error_page.dart';

class CheckPermission extends StatefulWidget {
  @override
  _CheckPermissionState createState() => _CheckPermissionState();
}

class _CheckPermissionState extends State<CheckPermission> {
  @override
  void initState() {
    super.initState();
    _checkPermissionOnStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
      ),
    );
  }

  void _checkPermissionOnStart() {
    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location)
        .then(_updateStatus);
  }

  void _updateStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.unknown:
        _askPermission();
        break;
      case PermissionStatus.denied:
        _askPermission();
        break;
      case PermissionStatus.neverAskAgain:
        _askPermission();
        break;
      case PermissionStatus.granted:
        Future(
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NearbyLocationPage(),
              ),
            );
          },
        );
        break;
      default:
    }
  }

  void _askPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.location]).then(
        _onStatusRequested);
  }

  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> status) {
    final newStatus = status[PermissionGroup.location];
    if (newStatus != PermissionStatus.granted) {
      Future(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PermissionErrorPage()));
      });
    } else {
      _updateStatus(newStatus);
    }
  }
}
