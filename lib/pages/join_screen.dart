import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/models/meeting_details.dart';
import 'package:frontend/pages/meeting_page.dart';
import 'package:frontend/pages/meeting_screen.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class JoinScreen extends StatefulWidget {
  final MeetingDetails meetingDetails;

  const JoinScreen({super.key, required this.meetingDetails});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Meeting'),
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
          SizedBox(
            height: 20,
          ),
          FormHelper.inputFieldWidget(context, 'userId', 'Enter your name ',
              (val) {
            if (val.isEmpty) {
              return 'Name is required';
            }
            return null;
          }, (onSaved) {
            userName = onSaved;
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
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return MeetingPage(
                          meetingId: widget.meetingDetails.id,
                          name: userName,
                          meetingDetail: widget.meetingDetails);
                    },
                  ));
                }
              })),
            ],
          )
        ]),
      ),
    );
  }

// 664ad161e97e43111280eaa3
  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
