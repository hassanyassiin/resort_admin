import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Handle_Images.dart';
import '../../../Global/Functions/Http_Exception.dart';

class Category_Model extends ChangeNotifier {
  final int id;
  String title;
  String photo;

  Category_Model({
    required this.id,
    required this.title,
    required this.photo,
  });

  Future<void> Edit_Category({
    XFile? new_photo,
    required String new_title,
  }) async {
    final url = Get_REQUEST_URL(
      is_form_data: true,
      url: '/admin-category/edit-Category',
    );

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Content-Type'] = "multipart/form-data; charset=UTF-8"
        ..headers['Authorization'] = 'Bearer $Get_Token'
        ..fields['categoryId'] = id.toString()
        ..fields['categoryTitle'] = new_title;

      if (new_photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('categoryImage', new_photo.path,
              contentType:
                  MediaType('Image', Get_Image_Type(File(new_photo.path)))),
        );
      }

      var stream_response = await request.send();
      var response = await http.Response.fromStream(stream_response);

      final response_data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      title = new_title;

      if (new_photo != null) {
        photo = Get_PHOTO_URL(
          folder: 'category',
          image: response_data['imageUrl'],
        );
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
