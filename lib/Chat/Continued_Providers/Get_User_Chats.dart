import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';

import '../../../Chat/Providers/Chat_Model.dart';
import '../../../Chat/Providers/User_Chat_Model.dart';

Future<List<User_Chat_Model>> Cd_Get_User_Chats() async {
  final url = Get_REQUEST_URL(url: '/admin-chat/get-User-Chats');

  try {
    final response = await http.get(url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

    final response_data = json.decode(response.body);

    print(response_data);

    if (response.statusCode != 200) {
      throw C_Http_Exception(response_data['ErrorFound'] ?? '');
    }

    List<User_Chat_Model> received_user_chats = [];

    for (var user_chat in response_data['userChats']) {
      List<Chat_Model> received_chats = [];

      for (var chat in user_chat['chats']) {
        received_chats.add(
          Chat_Model(id: chat['id'], text: chat['text']),
        );
      }

      received_user_chats.add(
        User_Chat_Model(
          id: user_chat['id'],
          is_refresh: user_chat['isRefresh'],
          user_name:
              "${user_chat['user']['firstName']} ${user_chat['user']['lastName']}",
          user_pic: Get_PHOTO_URL(
              folder: 'profile', image: user_chat['user']['profilePic']),
          chats: received_chats,
        ),
      );
    }

    return received_user_chats;
  } catch (error) {
    rethrow;
  }
}
