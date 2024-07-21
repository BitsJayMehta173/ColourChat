import 'package:flutter/material.dart';
import 'chatscreen.dart';
import 'globals.dart' as globals;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';


class Contact {
  final String userName;
  final String phoneNumber;

  Contact(this.userName, this.phoneNumber);

  factory Contact.fromMap(Map<String, dynamic> data) {
    return Contact(
      data['userName'] ?? 'Unnamed',
      data['phoneNumber'] ?? '',
    );
  }
}


class Addfriend extends StatefulWidget {
  const Addfriend({super.key});

  @override
  State<Addfriend> createState() => _AddfriendState();
}

class _AddfriendState extends State<Addfriend> {
  final List<Contact> contacts = [];

  // We will maintain all our friends friends list here in this new collection
  final DatabaseReference contactRef = FirebaseDatabase.instance
      .ref()
      .child('graph/${globals.phonenumber}/friendlist');//replace testPhoneNumber with your number here
  // first we need to find out our friends then again use the same function to find people we can connect with our through our friend so we need to request data two times
      @override
  void initState() {
    super.initState();
    _listenForContacts();
  }

    void _listenForContacts() {
    contactRef.onValue.listen((event) {
      final List<String> ourFriends = [];
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      // print(data);
      data.forEach((key, value) {
        // newContacts.add(Contact.fromMap(Map<String, dynamic>.from(value)));
        print(value);
        ourFriends.add(value['phoneNumber']);
      });
      // print(newContacts);

      for (int i = 0; i < ourFriends.length; i++) {
        print(ourFriends[i]);
        final DatabaseReference friendcontactRef = FirebaseDatabase.instance
        .ref()
        .child('graph/${ourFriends[i]}/friendlist');
        friendcontactRef.onValue.listen((event) {
      final ndata = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Contact> newContacts = [];
      // print(data);
      ndata.forEach((k, v) {
        newContacts.add(Contact.fromMap(Map<String, dynamic>.from(v)));
      });
      // print(newContacts);
      setState(() {
        contacts.clear();
        contacts.addAll(newContacts);
      });
    });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(contacts[index].userName[0]),
            ),
            title: Text(contacts[index].userName),
            subtitle: Text(contacts[index].phoneNumber),
            onTap: () {
              globals.currfriend = contacts[index].phoneNumber;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          );
        },
      )
    );
  }
}