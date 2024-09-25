import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class GraphNet extends StatefulWidget {
  const GraphNet({super.key});

  @override
  State<GraphNet> createState() => _GraphNetState();
}

class _GraphNetState extends State<GraphNet> {
  @override
  void initState() {
    // make new collection in db
    final DatabaseReference signupref = FirebaseDatabase.instance.ref('graph');

    signupref.set({
      "7011205823": {
        "friendlist": {
          "6000144826": {
            "phoneNumber": "6000144826",
            "uniquePublicKey": "24032002",
            "userName": "Ana",
          },
        },
      },
      "6000144826": {
        "friendlist": {
          "7011205823": {
            "phoneNumber": "7011205823",
            "uniquePublicKey": "24032002",
            "userName": "Jay",
          },
          "9851155511": {
            "phoneNumber": "9851155511",
            "uniquePublicKey": "24032002",
            "userName": "Dad",
          }
        },
      }
    });

    // signupref.set({
    //   "testPhoneNumber": {
    //     "friendlist": {
    //       "testReciPhoneNumber": {
    //         "phoneNumber": "testReciFriendPhoneNumber",
    //         "uniquePublicKey": "24032002",
    //         "userName": "Jay",
    //       },
    //     },
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text('Contacts'),
      ),
      body:Text("The"));
  }
}
