import 'package:flutter/material.dart';
import 'chatlist.dart';
import 'globals.dart' as globals;

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
                  IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactListApp()),
                    );
                  },
                )
        ],
      ),
    );
  }
}