import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/nearby_location/presentation/pages/nearby_location_page.dart';

class PermissionErrorPage extends StatefulWidget {
  const PermissionErrorPage({Key key}) : super(key: key);

  @override
  _PermissionErrorPageState createState() => _PermissionErrorPageState();
}

class _PermissionErrorPageState extends State<PermissionErrorPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.location)
          .then(_updateStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0XFFF1F2F6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Center(
                    child: Icon(
                      Icons.location_off,
                      color: Color(0XFF242F3E),
                      size: 40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "Aplikasi ini membutuhkan izin lokasi agar berfungsi dengan normal!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Izinkan Lokasi",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Color(0XFF242F3E),
                      onPressed: (() async {
                        bool isOpened =
                            await PermissionHandler().openAppSettings();
                        print(isOpened);
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateStatus(PermissionStatus status) {
    if (status == PermissionStatus.granted) {
      Future(() {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NearbyLocationPage()));
      });
    }
  }
}
