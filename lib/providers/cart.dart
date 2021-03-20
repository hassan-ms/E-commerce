import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/cart_item.dart';


// class CartItem {
//   final String id;
//   final String title;
//   final int quantity;
//   final double price;

//   CartItem(
//       {@required this.id,
//       @required this.title,
//       @required this.quantity,
//       @required this.price});
// }

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};  

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
        (key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  Future<void> addItem(String productId, double price, String title) async{
    if (_items.containsKey(productId)) {
      
      // final url = 'https://shop-79395.firebaseio.com/$id/cart.json';
      // http.patch(url,)
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              productId: productId,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));

    } else {
    const url = 'https://shop-79395.firebaseio.com/cart.json';
      final response = await http.post(url,body: json.encode({
        'title':title,
        'quantity':1,
        'price':price,
      }));
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: json.decode(response.body)['name'],
                title: title,
                quantity: 1,
                price: price,
                productId: productId,
              ));

    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleProduct(productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCard) => CartItem(
                id: existingCard.id,
                title: existingCard.title,
                price: existingCard.price,
                productId: existingCard.productId,
                quantity: existingCard.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
