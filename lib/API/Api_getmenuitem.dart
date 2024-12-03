import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/menuitem_model.dart';

class ApiServiceMenu {
//   String url = "https://prakrutitech.buzz/Dhaval/selectmenu.php";

  Future<List<Menuitem>> fetchMenuItems(String shopId) async {
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/selectmenu.php");
    final response = await http.post(url, body: {"shopid": shopId});

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Menuitem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }
}
