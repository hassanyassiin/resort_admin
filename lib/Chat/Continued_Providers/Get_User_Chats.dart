import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

import '../../../Chat/Providers/User_Chat_Model.dart';

Future<List<User_Chat_Model>> Cd_Get_User_Chats() async {
  final url = Get_REQUEST_URL(url: '/admin-chat/get-User-Chats');

  try {
    final response = await http.get(url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

    final response_data = json.decode(response.body);

    if (response.statusCode != 200) {
      throw C_Http_Exception(response_data['ErrorFound'] ?? '');
    }

    List<User_Chat_Model> received_user_chats = [];

    for (var user_chat in response_data['userChats']) {
      received_user_chats.add(
        User_Chat_Model(
          id: user_chat['id'],
          is_refresh: user_chat['isRefresh'],
          user_name: user_chat['user']['name'],
          user_pic: Get_PHOTO_URL(
              folder: 'profile', image: user_chat['user']['profilePic']),
        ),
      );
    }

    return received_user_chats;
  } catch (error) {
    rethrow;
  }
}
