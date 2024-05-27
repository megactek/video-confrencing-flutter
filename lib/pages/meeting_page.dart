import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_webrtc_wrapper/flutter_webrtc_wrapper.dart';
import 'package:frontend/models/meeting_details.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/utils/user.utils.dart';
import 'package:frontend/widgets/control_panel.dart';
import 'package:frontend/widgets/remote_connection.dart';

class MeetingPage extends StatefulWidget {
  final String? meetingId;
  final String? name;
  final MeetingDetails? meetingDetail;
  const MeetingPage(
      {super.key, this.meetingId, required this.meetingDetail, this.name});

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage> {
  final _localRender = RTCVideoRenderer();
  final Map<String, dynamic> mediaConstraints = {'audio': true, 'video': true};
  bool isConnectionFailed = false;
  WebRTCMeetingHelper? meetingHelper;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: _buildMeetingRoom(),
      bottomNavigationBar: ControlPanel(
        onAudioToggle: onAudioToggle,
        onVideoToggle: onVideoToggle,
        videoEnabled: isVideoEnabled(),
        audioEnabled: isAudioEnabled(),
        isConnectionFailed: isConnectionFailed,
        onReconnect: handleReconnect,
        onMeetingEnd: onMeetingEnd,
      ),
    );
  }

  void startMeeting() async {
    final String userId = await loadUserId();
    meetingHelper = WebRTCMeetingHelper(
      url: 'http://127.0.0.1:4000',
      meetingId: widget.meetingDetail!.id,
      userId: userId,
      name: widget.name,
    );
    MediaStream _localStream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRender.srcObject = _localStream;
    meetingHelper!.stream = _localStream;

    meetingHelper!.on('open', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on('connection', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on('user-left', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });

    meetingHelper!.on('video-toggle', context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on('audio-toggle', context, (ev, context) {
      setState(() {});
    });

    meetingHelper!.on('meeting-ended', context, (ev, context) {
      onMeetingEnd();
    });

    meetingHelper!.on('conection-setting-changed', context, (ev, context) {
      setState(() {
        isConnectionFailed = false;
      });
    });
    setState(() {});
  }

  initRenders() async {
    await _localRender.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenders();
    startMeeting();
  }

  @override
  void deactivate() {
    super.deactivate();
    _localRender.dispose();
    if (meetingHelper != null) {
      meetingHelper!.destroy();
      meetingHelper = null;
    }
  }

  void onMeetingEnd() {
    if (meetingHelper != null) {
      meetingHelper!.endMeeting();
      meetingHelper = null;
      goToHomepage();
    }
  }

  _buildMeetingRoom() {
    return Stack(
      children: [
        meetingHelper != null && meetingHelper!.connections.isNotEmpty
            ? GridView.count(
                crossAxisCount: meetingHelper!.connections.length < 3 ? 1 : 2,
                children:
                    List.generate(meetingHelper!.connections.length, (index) {
                  return Padding(
                    padding: EdgeInsets.all(1),
                    child: RemoteConnection(
                      renderer: meetingHelper!.connections[index].renderer,
                      connection: meetingHelper!.connections[index],
                    ),
                  );
                }),
              )
            : Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Waiting for perticipants...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
        Positioned(
          child: SizedBox(
            width: 150,
            height: 200,
            child: RTCVideoView(_localRender),
          ),
          bottom: 10,
          right: 0,
        )
      ],
    );
  }

  void onAudioToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleAudio();
      });
    }
  }

  void onVideoToggle() {
    if (meetingHelper != null) {
      setState(() {
        meetingHelper!.toggleVideo();
      });
    }
  }

  bool isAudioEnabled() {
    return meetingHelper != null ? meetingHelper!.audioEnabled! : false;
  }

  bool isVideoEnabled() {
    return meetingHelper != null ? meetingHelper!.videoEnabled! : false;
  }

  void handleReconnect() {
    if (meetingHelper != null) {
      meetingHelper!.reconnect();
    }
  }

  void goToHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
