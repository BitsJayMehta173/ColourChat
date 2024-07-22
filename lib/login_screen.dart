import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'chatlist.dart';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String qrText = "";
  Map<String, bool> vis = {};

  void _onTextChanged(String value) {
    setState(() {
      globals.phonenumber = value;
    });
  }

  void tablegen(int min, int max, String curr) {
    bool flag = true;
    while (flag) {
      String val = "";
      flag = false;
      for (int i = 0; i < 4; i++) {
        int choice = Random().nextInt(3) + 1;
        if (choice == 1) {
          int x = Random().nextInt(max - min + 1) + min;
          val += x.toString();
        }
        if (choice == 2) {
          String y = String.fromCharCode(
              Random().nextInt('z'.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1) +
                  'a'.codeUnitAt(0));
          val += y;
        }
        if (choice == 3) {
          String z = String.fromCharCode(
              Random().nextInt('Z'.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1) +
                  'A'.codeUnitAt(0));
          val += z;
        }
      }
      if (vis.containsKey(val)) {
        flag = true;
        continue;
      }
      vis[val] = true;
      qrText += curr;
      qrText += ":";
      qrText+=val;
      qrText += "\n";
    }
  }

  Future<void> _hashcreate() async {
    print("here is");
    for (int i = 'a'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
      tablegen(0, 9, String.fromCharCode(i));
    }

    for (int i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++) {
      tablegen(0, 9, String.fromCharCode(i));
    }
    tablegen(0, 9, " ");
    tablegen(0, 9, "uniquepublickey");
    print(qrText);
    await _storeQRText();

    // We need to maintain two files one current and another history which i have not done here
  }

  Future<void> _storeQRText() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    // /data/user/0/com.example.chatapp/app_flutter/qrText.txt
    final file = File('$path/1.txt');
    await file.writeAsString(qrText);
    print('$path/1.txt');
    print('done');
    // _readQRText();
  }

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> checkIfNodeExists(String nodeName) async {
    DatabaseEvent event = await _databaseReference.child(nodeName).once();
    if (event.snapshot.value != null) {
      _hashcreate();
      // Node exists, navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactListApp()),
      );
    } else {
      // Node does not exist, show a toast message
      Fluttertoast.showToast(
        msg: 'Please sign up',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'Enter Phone Number'),
            onChanged: _onTextChanged,
          ),
          ElevatedButton(
            onPressed: () {
              checkIfNodeExists('${globals.phonenumber}');
            },
            child: Text('LogIn'),
          ),
          ElevatedButton(
            onPressed: () {
              final DatabaseReference signupref =
                  FirebaseDatabase.instance.ref('${globals.phonenumber}');
              // just for test purpose i have hardcoded later i will put nothing for the collection data for signup but just the time of signup
              signupref.set({
                "friendlist": {
                  "${globals.phonenumber}": {
                    "phoneNumber": "${globals.phonenumber}",
                    "uniquePublicKey": "24032002",
                    "userName": "TestUser",
                  },
                },
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactListApp()),
              );
            },
            child: Text('SignUp'),
          ),
        ],
      ),
    );
  }
}
