import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../widgets/cart_item.dart';


class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  

  OrderItem(
      {@required this.id,
      @required this.products,
      @required this.amount,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
   String authTocken;
    String _userId;

  void setData(String tok,var ords,String uId){
    authTocken=tok;
    _orders=ords;
    _userId=uId;
    
  }
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = 'https://shop-79395.firebaseio.com/orders/$_userId.json?auth=$authTocken';
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProduct.map((cprod) {
            return {
              'id': cprod.id,
              'title': cprod.title,
              'quantity': cprod.quantity,
              'price': cprod.price,
            };
          }).toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          products: cartProduct,
          amount: total,
          dateTime: timeStamp,
        ));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://shop-79395.firebaseio.com/orders/$_userId.json?auth=$authTocken';
    try {
      final response = await http.get(url);
      final List<OrderItem> _loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((key, orderData) {
        _loadedOrders.add(OrderItem(
            id: key,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']);
            }).toList()));
      });
      _orders=_loadedOrders.reversed.toList();
    } catch (e) {
      throw e;
    }
  }
}
