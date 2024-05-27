import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class ControlPanel extends StatelessWidget {
  final bool? videoEnabled;
  final bool? audioEnabled;
  final bool? isConnectionFailed;
  final VoidCallback? onVideoToggle;
  final VoidCallback? onAudioToggle;
  final VoidCallback? onReconnect;
  final VoidCallback? onMeetingEnd;

  const ControlPanel(
      {super.key,
      this.videoEnabled,
      this.audioEnabled,
      this.isConnectionFailed,
      this.onAudioToggle,
      this.onVideoToggle,
      this.onReconnect,
      this.onMeetingEnd});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buildControls(),
      ),
      color: Colors.blueGrey[900],
      height: 60.0,
    );
  }

  List<Widget> buildControls() {
    if (!isConnectionFailed!) {
      return <Widget>[
        IconButton(
          onPressed: onVideoToggle,
          icon: Icon(videoEnabled! ? Icons.videocam : Icons.videocam_off),
          color: Colors.white,
          iconSize: 32,
        ),
        IconButton(
          onPressed: onAudioToggle,
          icon: Icon(videoEnabled! ? Icons.mic : Icons.mic_off),
          color: Colors.white,
          iconSize: 32,
        ),
        SizedBox(
          width: 25,
        ),
        Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: IconButton(
            icon: Icon(Icons.call_end),
            color: Colors.white,
            onPressed: onMeetingEnd!,
          ),
        )
      ];
    } else {
      return <Widget>[
        FormHelper.submitButton('Reconnect', onReconnect!,
            btnColor: Colors.red, borderRadius: 10, width: 200, height: 40)
      ];
    }
  }
}
