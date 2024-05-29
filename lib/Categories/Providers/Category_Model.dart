import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../Authentication/Providers/Authentication.dart';

import '../../../Global/Functions/Handle_Images.dart';
import '../../../Global/Functions/Http_Exception.dart';

import '../../../Products/Providers/Product_Model.dart';

class Category_Model extends ChangeNotifier {
  final int id;
  String title;
  String photo;
  List<Product_Model> products;

  Category_Model({
    required this.id,
    required this.title,
    required this.photo,
    required this.products,
  });

  var is_get_products_success = false;
  get Get_Is_Get_Products_Success => is_get_products_success;

  Future<void> Get_Products() async {
    final url = Get_REQUEST_URL(url: 'admin-category/get-Products');

    try {
      final response = await http.get(url,
          headers: <String, String>{'Authorization': 'Bearer $Get_Token'});

      final response_data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      List<Product_Model> received_products = [];

      for (var product in response_data['products']) {
        received_products.add(
          Product_Model(
            id: product['id'],
            title: product['title'],
            photo: Get_PHOTO_URL(
              folder: 'product',
              image: product['photo'],
            ),
          ),
        );
      }

      products = received_products;
      is_get_products_success = true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> Delete_Product({required int product_id}) async {
    final url = Get_REQUEST_URL(
        url: '/admin-product/delete-Product',
        arguments: {'productId': product_id.toString()});

    try {
      final response = await http.delete(
        url,
        headers: <String, String>{'Authorization': 'Bearer $Get_Token'},
      );

      final response_data = json.decode(response.body);

      if (response.statusCode != 200) {
        throw C_Http_Exception(response_data['ErrorFound'] ?? '');
      }

      products.removeWhere((product) => product.id == product_id);

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }


  Future<void> Create_Product({
    required String title,
    required XFile photo,
  }) async {
    final url = Get_REQUEST_URL(
        is_form_data: true, url: "/admin-product/create-Product");

    final image_type = Get_Image_Type(File(photo.path));

    try {
      var request = http.MultipartRequest('POST', url)
        ..headers['Content-Type'] = "multipart/form-data; charset=UTF-8"
        ..headers['Authorization'] = 'Bearer $Get_Token'
        ..fields['categoryId'] = id.toString()
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

      products.insert(
        0,
        Product_Model(
          title: title,
          id: response_data['id'],
          photo: Get_PHOTO_URL(
            folder: 'product',
            image: response_data['photoUrl'],
          ),
        ),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

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
