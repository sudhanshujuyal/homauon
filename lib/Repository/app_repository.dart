
import 'dart:convert';

import '../Constant/constant.dart';
import '../model/appinfo.dart';
import 'package:http/http.dart' as http;

class AppRepository
{

  static Future<AppInfo> getAppInfo() async {
    Map mapData ={
      'key':Constants.key,
      'code':Constants.code,
      'erp_name':Constants.erpName,
      'app_name':Constants.appName,

    };
    final response = await http.post(Uri.parse(Constants.baseUrl),body:mapData);

    if (response.statusCode == 200) {
      return AppInfo.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Info');
    }


  }
}