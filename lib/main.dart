
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:failedtoconnect/driver-side_app/main.dart';
import 'package:failedtoconnect/user_side_app/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'user_side_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Permission.locationWhenInUse.request();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Combined Uber App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserTypeSelector(),
    );
  }
}

class UserTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select User Type')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => userapp()),
                );
              },
              child: Text('User'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => driverapp()),
                );
              },
              child: Text('Driver'),
            ),
          ],
        ),
      ),
    );
  }
}
