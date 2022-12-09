import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  NetworkHelper(this.url, this.postJson);
  final String url;
  final String postJson;
  Future getData() async {
    final prefs = await SharedPreferences.getInstance();
    http.Response response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Authorization": "basic ${prefs.getString('token')}"
    });

    if (response.statusCode == 200) {
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future postData() async {
    final prefs = await SharedPreferences.getInstance();
    print('postJson = $postJson');
    http.Response response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "basic ${prefs.getString('token')}"
        },
        body: postJson);

    if (response.statusCode == 200) {
      String data = response.body;
      //print('res in networking = $data');
      return jsonDecode(data);
    } else {
      print('statusCode ${response.statusCode}');
    }
  }
}
