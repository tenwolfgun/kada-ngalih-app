import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_service_error_page.dart';
import 'check_permission.dart';
import 'injection_container.dart' as di;

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    RestartWidget(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0XFF121212),
        statusBarBrightness: Brightness.light,
        // statusBarColor: Color(0XFF121212)),
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Montserrat'),
      title: "Kada Ngalih",
      home: CheckService(),
    );
  }
}

class RestartWidget extends StatefulWidget {
  RestartWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>().restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class CheckService extends StatefulWidget {
  @override
  _CheckServiceState createState() => _CheckServiceState();
}

class _CheckServiceState extends State<CheckService> {
  @override
  void initState() {
    _checkService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _checkService() {
    PermissionHandler()
        .checkServiceStatus(PermissionGroup.location)
        .then(_updateStatus);
  }

  void _updateStatus(ServiceStatus status) {
    switch (status) {
      case ServiceStatus.enabled:
        Future(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CheckPermission()));
        });
        break;
      case ServiceStatus.disabled:
        _askPermission();
        break;
      case ServiceStatus.unknown:
        _askPermission();
        break;
    }
  }

  void _askPermission() {
    Future(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => LocationServiceErrorPage()));
    });
  }
}
