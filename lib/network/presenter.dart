

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supreox_skill_test/models/products_model.dart';
import 'package:supreox_skill_test/network/app_services.dart';

import 'base_client.dart';

Future<dynamic> initProductListInfo(BuildContext context,) async {
  String url = AppService.apiBaseUrl;


  Map body = {
    // 'page': page,
    // 'limit': "10",
  };

  Map<String, String> headerMap = {
    "Authorization": "Bearer c41048d9ef7f0ca276ffe639397af571"
  };

  var response = await BaseClient().getMethodWithoutHeader(url);

  if (response != null) {
    try {
      ProductsModel productsModel =
      ProductsModel.fromJson(json.decode(response));

      return productsModel;
    } catch (e) {
      return initProductListInfo(context);
    }
  } else {
    // return AppString.errorMsg;
  }
}
