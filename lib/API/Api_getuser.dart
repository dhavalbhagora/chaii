import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/usermodel.dart';

class ApiService {
  //final String url = "https://prakrutitech.buzz/Dhaval/getuser.php";

  Future<List<UserModel>> fetchMenuItems(String shopId) async {
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/getuser.php");
    final response = await http.post(url, body: {"shopid": shopId});

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }
}
