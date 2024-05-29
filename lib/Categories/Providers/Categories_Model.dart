import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Http_Exception.dart';
import '../../../Global/Functions/Handle_Images.dart';

import '../../../Categories/Providers/Category_Model.dart';

class Categories_Model extends ChangeNotifier {
  List<Category_Model> _categories = [];
  List<Category_Model> get Get_Local_Categories => _categories;

  var is_get_categories_success = false;
  get Get_Is_Get_Categories_Success => is_get_categories_success;

  Future<void> Get_Categories() async {
    final url = Get_REQUEST_URL(url: 'admin-category/get-Categories');

    try {
      final response = await http.get(url,
          headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

      final response_data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      List<Category_Model> received_categories = [];

      for (var category in response_data['categories']) {
        received_categories.add(
          Category_Model(
            id: category['id'],
            title: category['title'],
            products: [],
            photo: Get_PHOTO_URL(
              folder: 'category',
              image: category['photo'],
            ),
          ),
        );
      }

      _categories = received_categories;
      is_get_categories_success = true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> Delete_Category({required int category_id}) async {
    final url = Get_REQUEST_URL(
        url: '/admin-category/delete-Category',
        arguments: {'categoryId': category_id.toString()});

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'},
      );

      final response_data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      _categories.removeWhere((category) => category.id == category_id);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> Create_Category({
    required String title,
    required XFile photo,
  }) async {
    final url = Get_REQUEST_URL(
        is_form_data: true, url: "/admin-category/create-Category");

    final image_type = Get_Image_Type(File(photo.path));

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Content-Type'] = "multipart/form-data; charset=UTF-8"
        ..headers['Authorization'] = 'Bearer $Get_Token'
        ..files.add(http.MultipartFile.fromString(
          'title',
          title,
          contentType: MediaType('text', 'plain'),
        ))
        ..files.add(await http.MultipartFile.fromPath(
          'photo',
          photo.path,
          contentType: MediaType('image', image_type),
        ));

      var stream_response = await request.send();
      var response = await http.Response.fromStream(stream_response);

      final response_data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      _categories.insert(
        0,
        Category_Model(
          title: title,
          id: response_data['id'],
          photo: Get_PHOTO_URL(
            folder: 'category',
            image: response_data['photoUrl'],
          ),
          products: [],
        ),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
