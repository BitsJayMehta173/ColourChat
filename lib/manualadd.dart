import 'package:chatapp/chatscreen.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Manualadd extends StatefulWidget {
  const Manualadd({super.key});

  @override
  State<Manualadd> createState() => _ManualaddState();
}

class _ManualaddState extends State<Manualadd> {
  void _onTextChanged(String value) {
    setState(() {
      globals.currfriend = value;
    });
  }

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> checkIfNodeExists(String nodeName) async {
    DatabaseEvent event = await _databaseReference.child(nodeName).once();
    if (event.snapshot.value != null) {
      // Node exists, navigate to the next screen
      final DatabaseReference newfriendref = FirebaseDatabase.instance
          .ref()
          .child('${globals.phonenumber}/friendlist');
      newfriendref.update({
        "${globals.currfriend}": {
          "phoneNumber": "${globals.currfriend}",
          "uniquePublicKey": "24032002",
          "userName": "${globals.currfriend}",
        }
      });
      final DatabaseReference newwfriendref = FirebaseDatabase.instance
          .ref()
          .child('${globals.currfriend}/friendlist');
      newwfriendref.update({
        "${globals.phonenumber}": {
          "phoneNumber": "${globals.phonenumber}",
          "uniquePublicKey": "24032002",
          "userName": "${globals.phonenumber}",
        }
      });

      final DatabaseReference graphref = FirebaseDatabase.instance
          .ref('graph/${globals.phonenumber}/friendlist');
      graphref.update({
        "${globals.currfriend}": {
          "phoneNumber": "${globals.currfriend}",
          "uniquePublicKey": "24032002",
          "userName": "${globals.currfriend}",
        },
      });
      final DatabaseReference graphref1 = FirebaseDatabase.instance
          .ref('graph/${globals.currfriend}/friendlist');
      graphref1.update({
        "${globals.phonenumber}": {
          "phoneNumber": "${globals.phonenumber}",
          "uniquePublicKey": "24032002",
          "userName": "${globals.currfriend}",
        },
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    } else {
      // Node does not exist, show a toast message
      Fluttertoast.showToast(
        msg: 'User Not Found',
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
        title: Text('Add Nearby Friend'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: 'Enter Phone Number'),
            onChanged: _onTextChanged,
          ),
          ElevatedButton(
            onPressed: () {
              checkIfNodeExists('${globals.currfriend}');
            },
            child: Text('Find'),
          )
        ],
      ),
    );
  }
}
