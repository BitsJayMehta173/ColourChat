import 'package:flutter/material.dart';
import 'chatlist.dart';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void _onTextChanged(String value) {
    setState(() {
      globals.phonenumber = value;
    });
  }

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> checkIfNodeExists(String nodeName) async {
    DatabaseEvent event = await _databaseReference.child(nodeName).once();
    if (event.snapshot.value != null) {
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
                  "7011205823": {
                    "phoneNumber": "7011205823",
                    "uniquePublicKey": "24032002",
                    "userName": "Jay",
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
