import 'package:chatapp/chatscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart' as globals;
import 'package:path_provider/path_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ContactListApp());
}

class ContactListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ContactListPage(),
    );
  }
}

class Contact {
  final String userName;
  final String phoneNumber;


  Contact(this.userName,this.phoneNumber);

  factory Contact.fromMap(Map<String, dynamic> data) {
    return Contact(
      data['userName'] ?? 'Unnamed',
      data['phoneNumber'] ?? '',
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  final List<Contact> contacts = [];
  final DatabaseReference contactRef = FirebaseDatabase.instance.ref().child('${globals.phonenumber}/friendlist');

  @override
  void initState() {
    super.initState();
    // for the first time when user sign up we need to make sure of this meanwhile you can keep friendlist and messages empty
    // contactRef.set({
    //   'friendlist':{
    //     'friend1':{
    //       'userName':'Ana',
    //       'phoneNumber':'6000155937',
    //       'messages':{
    //           'text': 'Hi',
    //           'timestamp': DateTime.now().millisecondsSinceEpoch,
    //           'isSentByMe': false,
    //       },
    //       'uniquePublicKey':'24032002',
    //     },
    //   },
    // });
    _listenForContacts();
  }

  void _listenForContacts() {
    contactRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Contact> newContacts = [];
      // print(data);
      data.forEach((key, value) {
        newContacts.add(Contact.fromMap(Map<String, dynamic>.from(value)));
      });
      // print(newContacts);
      setState(() {
        contacts.clear();
        contacts.addAll(newContacts);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
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
              globals.currfriend=contacts[index].phoneNumber;
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen()),
                    );
            },
          );
        },
      ),
    );
  }
}
