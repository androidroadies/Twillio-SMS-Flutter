import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:http/http.dart' as http;


String TWILIO_SMS_API_BASE_URL = 'https://api.twilio.com/2010-04-01';
String toAuthCredentials(String accountSid, String authToken) =>
    base64.encode(utf8.encode(accountSid + ':' + authToken));

class MyTwilio {
  final String _accountSid;
  final String _authToken;

  const MyTwilio(this._accountSid, this._authToken);

  Messages get messages => Messages(_accountSid, _authToken);
}

class Messages {
  final String _accountSid;
  final String _authToken;

  const Messages(this._accountSid, this._authToken);

  Future<Map> create(data) async {
    var client = http.Client();

    var url =
        '$TWILIO_SMS_API_BASE_URL/Accounts/$_accountSid/Messages.json';

    try {
      var response = await client.post(Uri.parse(url), headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${toAuthCredentials(_accountSid, _authToken)}'
      }, body: {
        'From': data['from'],
        'To': data['to'],
        'Body': data['body']
      });

      return (json.decode(response.body));
    } catch (e) {
      return ({'Runtime Error': e});
    } finally {
      client.close();
    }
  }
}

Future<void> main() async {
  // See http://twil.io/secure for important security information


  // Your Account SID and Auth Token from www.twilio.com/console
  // You can skip this block if you store your credentials in environment variables


  // Create an authenticated client instance for Twilio API
  // var client = const MyTwilio('AC26af0f4241f500f1d4ed386d5a6f89df', '3d3f1726ec8d2dd98f23549986d25641');
  //
  // // Send a text message
  // // Returns a Map object (key/value pairs)
  // Map message = await client.messages.create({
  //   'body': 'Hello from Dart! vikram',
  //   'from': '+16413326496', // a valid Twilio number
  //   'to': '+919327420569' // your phone number
  // });
  //
  // // access individual properties using the square bracket notation
  // // for example print(message['sid']);
  // print(message);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Twilio SMS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    twilioFlutter =
        TwilioFlutter(accountSid: 'AC26af0f4241f500f1d4ed386d5a6f89df', authToken: '3d3f1726ec8d2dd98f23549986d25641', twilioNumber: '+16413326496');

    super.initState();
  }

  void sendSms() async {
    twilioFlutter.sendSMS(toNumber: '+917984032522', messageBody: 'Twilio Test Prince test new number');
  }


  void getSms() async {
    var data = await twilioFlutter.getSmsList();
    print(data);

    await twilioFlutter.getSMS('***************************');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused)) {
                        return Colors.red;
                      }
                      return null; // Defer to the widget's default.
                    }
                ),
              ),
              onPressed:() async {
                sendSms();
                // var client = const MyTwilio('AC26af0f4241f500f1d4ed386d5a6f89df', '3d3f1726ec8d2dd98f23549986d25641');
                //
                // // Send a text message
                // // Returns a Map object (key/value pairs)
                // Map message = await client.messages.create({
                //   'body': 'Hello from Dart! vikram 2',
                //   'from': '+16413326496', // a valid Twilio number
                //   //'to': '+916353598656' // your phone number
                //   'to': '+919427131647' // your phone number
                // });
                //
                // // access individual properties using the square bracket notation
                // // for example print(message['sid']);
                // print(message);
              },
              child: const Text('Send SMS'),
            )
          ],
        ),
      ),
    );
  }
}
