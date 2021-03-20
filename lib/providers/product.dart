import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFav = false});

  void toggleFav(String authTocken,String userId) async {
    final url = 'https://shop-79395.firebaseio.com/userFavorits/$userId/$id.json?auth=$authTocken';

    await http.put(url,
        body: json.encode(
         !isFav,
        ));
    isFav = !isFav;
    notifyListeners();
  }
}
