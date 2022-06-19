import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stic_flutter_task/model/ProductData.dart';
import 'package:stic_flutter_task/notification/NotificationService.dart';

class JsonDataProvider extends ChangeNotifier {
  List<Products>? productList;
  List<Products>? filteredProductList;
  Timer? timer;

  Future<void> readProductsJson() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);

    ProductData productData = ProductData.fromJson(data);

    productList = productData.products;

    print('LIST ${jsonEncode(productList)}');

    notifyListeners();
  }

  Future<void> filterProducts(String searchText, BuildContext context) async {
    filteredProductList = [];

    if (searchText.isEmpty) {
      filteredProductList!.addAll(productList!);
    } else {
      filteredProductList = productList!
          .where((element) =>
              element.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              element.description!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }

  Future<void> startQuantityReductionTimer(BuildContext context) async {
    timer = Timer.periodic(Duration(minutes: 1), (timer) {
      Random random = Random();

      if (filteredProductList!.isNotEmpty) {
        Products product =
            filteredProductList![random.nextInt(filteredProductList!.length)];

        if (product.quantity! > 0) {
          product.quantity = product.quantity! - 1;

          String notificationMsg =
              "Only ${product.quantity} ${product.name} available now";

          showNotification(context, notificationMsg);

          notifyListeners();
        }
      } else {
        timer.cancel();
      }
    });  }

  Future<void> showNotification(BuildContext context, String notificationMsg) async {

    await NotificationService().showNotification(notificationMsg);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }
}
