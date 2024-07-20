import 'package:chatapp/chatscreen.dart';
import 'package:chatapp/firebase_options.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login_screen.dart';

// I have added file handle permission for tablestorage but i think it works without it too for now but later we have to consider a case where the users clears data it will clear all the files so we need to make a backup data for it then we will need permissions but we also have alternate to that to store data in home server. i believe server must host the AI/ML application rather than data for future.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('start');
  await _requestPermissions();
  runApp(MyApp());
}
  Future<void> _requestPermissions() async {
  // Request permissions for Android
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    // Request permission
    await Permission.storage.request();
    print('end');
  }

}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
