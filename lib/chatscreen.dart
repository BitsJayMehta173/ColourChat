import 'package:flutter/material.dart';
import 'message_model.dart';
import 'message_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'qr_view_example.dart'; 
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart' as globals;

final Map<String, String> keytablee = {};
final Map<String, String> reversekeytablee = {};
final Map<String, bool> vis = {};

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final Map<String, String> keytable = {};
  // final Map<String, String> reversekeytable = {};
  // final Map<String, bool> vis = {};




  final List<Message> _messages = [];
  final Map<int,int> vis={};
  final TextEditingController _controller = TextEditingController();
  final DatabaseReference messageRef = FirebaseDatabase.instance.ref().child('messages');
  List<Map<String, dynamic>> messages = [];


  @override
  void initState() {
    super.initState();
    _listenForMessages();
  }


  void _listenForMessages() {
    messageRef.onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<Map<String, dynamic>> newMessages = [];
      data.forEach((key, value) {
        
        if(!vis.containsKey(value['timestamp'])){
          vis[value['timestamp']]=1;
          newMessages.add(Map<String, dynamic>.from(value));
          print(value['isSentByMe']);
          if(value['phonenumber']==globals.phonenumber){
          _messages.add(Message(text: value['text'], isSentByMe: value['isSentByMe']));
          }
          else{
            _messages.add(Message(text: value['text'], isSentByMe: false));
          }
        }

      });
      setState(() {
        messages = newMessages;
        print(messages);
        // _messages=newMessages;
      });
    });
  }
  
  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    // String str="";
    String encoded="";
    for (int i = 0; i < _controller.text.length; i++) {
      // str+=_controller.text[i];
      encoded+=keytablee[_controller.text[i]]!;
  }
  // String temp=keytablee['a']!;
  // print('Type of numberAsString: ${temp.runtimeType}');
  // temp=temp.toString();
  // str+=temp;

    // final message = Message(text: encoded, isSentByMe: true);

  // As we have already implemented update in db we don't need to use setState here but later on we need it when there is connection error for draft message
    // setState(() {
    //   _messages.add(message);
    // });

    messageRef.push().set({
      'text': encoded,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'isSentByMe': true,
      'phonenumber':globals.phonenumber,
    });
    _controller.clear();
    // encoded="";
  }

  void _onTextChanged(String value) {
    setState(() {
      globals.phonenumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageWidget(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                )
              ],
            ),
          ),
          TextField(
                    decoration: InputDecoration(hintText: 'Enter Phone Number'),
                    onChanged: _onTextChanged,
                  )
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String qrText = ""; // Initial QR text input

  void tablegen(int min,int max,String curr){
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
          String y = String.fromCharCode(Random().nextInt('z'.codeUnitAt(0) - 'a'.codeUnitAt(0) + 1) + 'a'.codeUnitAt(0));
          val += y;
          }
          if (choice == 3) {
          String z = String.fromCharCode(Random().nextInt('Z'.codeUnitAt(0) - 'A'.codeUnitAt(0) + 1) + 'A'.codeUnitAt(0));
          val += z;
          }
          }
          if (vis.containsKey(val)) {
            flag = true;
            continue;
          }
          vis[val] = true;
          reversekeytablee[val] = curr;
          keytablee[curr] = val;
        }
  }

  void _hashcreate(){

      for (int i = 'a'.codeUnitAt(0); i <= 'z'.codeUnitAt(0); i++) {
        qrText+=String.fromCharCode(i);
        qrText+=":";
        tablegen(0, 9,String.fromCharCode(i));
        qrText+='\n';
      }

      for (int i = 'A'.codeUnitAt(0); i <= 'Z'.codeUnitAt(0); i++) {
        qrText+=String.fromCharCode(i);
        qrText+=":";
        tablegen(0, 9,String.fromCharCode(i));
        qrText+=keytablee[String.fromCharCode(i)]!;
        qrText+='\n';
      }

      tablegen(0, 9,"uniquepublickey");
      

  }

  @override
  void initState() {
    super.initState();
    _hashcreate(); // Call your function here
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator and Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text field to enter data for QR code generation as sometimes there can be mistakes we are not auto clearing but button can be added to clear
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                // (IMPORTANT) QR codes can hold up to 7,089 characters of numeric data, 4,296 characters of alphanumeric data, or 2,953 bytes (8-bit binary data) at the highest error correction level (Level H).
                onChanged: (newText) {
                  setState(() {
                    qrText = newText;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter text for QR code',
                ),
              ),
            ),
            // Button to generate QR code based on entered text
            ElevatedButton(
              onPressed: () {
                if (qrText.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateQRScreen(qrText: qrText),
                      // In main.dart itself
                    ),
                  );
                }
                // else{
                //   qrText="{\na: '6P1y',\nb: '9HFy',\nc: '55FP',\nd: '4178',\ne: '7xuX',\nf: 'vuuv',\ng: 'cPh4',\nh: 'sjz1',\ni: 'Ee9B',\nj: 'xoe6',\nk: '2dS2',\nl: '2T6D',\nm: 'OH3u',\nn: 'z1fH',\no: 'n558',\np: 'OZtZ',\nq: '2PHD',\nr: 'Ee34',\ns: 'r8jd',\nt: 'y8je',\nu: 'Gxnn',\nv: 'A9u0',\nw: '3dnj',\nx: '310x',\ny: '50g3',z: '107H',\nA: '56ki',\nB: '2EeR',\nC: '32xt',\nD: '00E2',\nE: 'J2g7',\nF: '93M5',G: '6Hf9',\nH: 'Tu2J',\nI: 'bQoo',\nJ: 'pTKE',\nK: '4El6',\nL: 'u4qv',\nM: '8DX2',\nN: 'ar4P',\nO: 'i45K',\nP: '4AsG',\nQ: '0cVR',\nR: 'nUlV',\nS: 't61B',\nT: '73fv',\nU: 'P0Pn',\nV: 'PWPt',\nW: '0tzH',\nX: '33yC',\nY: '4138',\nZ: '9nj5',\n' ': 'ubN1',\nuniquepublickey: 'njaW'\n}";
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => GenerateQRScreen(qrText: qrText),
                //       // In main.dart itself
                //     ),
                //   );
                // }
              },
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            // Button to navigate to QR code scanning screen
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRViewExample()),
                );
              },
              child: Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class GenerateQRScreen extends StatelessWidget {
  final String qrText;

  const GenerateQRScreen({Key? key, required this.qrText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate QR Code')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            QrImageView(
              data: qrText,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to previous screen
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
