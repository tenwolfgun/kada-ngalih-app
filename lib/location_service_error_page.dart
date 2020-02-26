import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'main.dart';

class LocationServiceErrorPage extends StatefulWidget {
  @override
  _LocationServiceErrorPageState createState() =>
      _LocationServiceErrorPageState();
}

class _LocationServiceErrorPageState extends State<LocationServiceErrorPage>
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
      Geolocator().isLocationServiceEnabled().then(_updateStatus);
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
                        "Aplikasi ini membutuhkan layanan lokasi agar berfungsi dengan normal!",
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Aktifkan Layanan Lokasi",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Color(0XFF242F3E),
                      onPressed: (() async {
                        final AndroidIntent intent = new AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS',
                        );
                        intent.launch();
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

  void _updateStatus(bool t) {
    if (t) {
      // Future(
      //   () {
      //     // Navigator.push(
      //     //     context, MaterialPageRoute(builder: (context) => Home()));
      //     RestartWidget.restartApp(context);
      //   },
      // );
      RestartWidget.restartApp(context);
    }
  }
}
