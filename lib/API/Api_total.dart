import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/totalmodal.dart';

class ApiTotal {
  Future<List<total>> fetchtotal(String shopId) async {
    if (shopId.isEmpty) {
      throw Exception('Shop ID is missing');
    }

    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/gettotal.php");
    final response = await http.post(url, body: {"shopid": shopId});

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => total.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch total amounts');
    }
  }
}
