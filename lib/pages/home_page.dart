import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/meeting_details.dart';
import 'package:frontend/pages/join_screen.dart';
import 'package:http/http.dart';
import 'package:frontend/api/meeting_api.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String meetingId = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meeting App'),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: globalKey,
        child: formUI(),
      ),
    );
  }

  formUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Welcome to Meeting App',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          FormHelper.inputFieldWidget(context, 'meetingId', 'Enter meeting ID',
              (val) {
            if (val.isEmpty) {
              return 'Meeting ID is required';
            }
            return null;
          }, (onSaved) {
            meetingId = onSaved;
          },
              borderRadius: 10,
              borderFocusColor: Colors.redAccent,
              borderColor: Colors.redAccent,
              hintColor: Colors.grey),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  child: FormHelper.submitButton('Join Meeting', () {
                if (validateAndSave()) {
                  validateMeeting(meetingId);
                }
              })),
              Flexible(
                  child: FormHelper.submitButton('Start Meeting', () async {
                var response = await startMeeting();
                final body = json.decode(response!.body);
                final meetId = body['data'];
                validateMeeting(meetId);
              }))
            ],
          )
        ]),
      ),
    );
  }

  void validateMeeting(String meetingId) async {
    try {
      Response response = await joinMeeting(meetingId);
      var data = json.decode(response.body);
      final meetingDetails = MeetingDetails.fromJSON(data['data']);
      gotoJoinScreen(meetingDetails);
    } catch (e) {
      FormHelper.showSimpleAlertDialog(
          context, 'Meeting App', 'Invalid Meeting ID', 'OK', () {
        Navigator.of(context).pop();
      });
    }
  }

  gotoJoinScreen(MeetingDetails meetingDetails) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => JoinScreen(
          meetingDetails: meetingDetails,
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
