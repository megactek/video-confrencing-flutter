import 'dart:convert';

import 'package:frontend/utils/user.utils.dart';
import 'package:http/http.dart' as http;

String MEETING_API_URL = 'http://127.0.0.1:4003/api/meeting';

var client = http.Client();

Future<http.Response?> startMeeting() async {
  Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

  var userId = await loadUserId();

  var response = await client.post(
    Uri.parse('$MEETING_API_URL/start'),
    headers: requestHeaders,
    body: jsonEncode(
      {'hostId': userId, 'hostName': ''},
    ),
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}

Future<http.Response> joinMeeting(String meetingId) async {
  var response = await http.get(
    Uri.parse('$MEETING_API_URL/join?meetingId=$meetingId'),
  );
  if (response.statusCode >= 200 && response.statusCode < 400) {
    return response;
  } else {
    throw UnsupportedError('meeting with id \'$meetingId\' not found');
  }
}
