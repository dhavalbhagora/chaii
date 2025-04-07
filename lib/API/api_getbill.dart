import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Model/bill_modal.dart';

class ApiServiceBill {
  Future<List<BillModal>> fetchBill(String shopId) async {
    // Use a POST request to send the shopId
    var url = Uri.parse("https://prakrutitech.buzz/Dhaval/getbill.php");
    final response = await http.post(url, body: {"shopid": '20'});

    if (response.statusCode == 200) {
      // Decode and map the response to a list of BillModal
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => BillModal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bills');
    }
  }
}
