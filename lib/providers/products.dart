import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
import 'package:file_picker/file_picker.dart';

class Products with ChangeNotifier {
  String authTocken;
  String userId;
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  void setData(var tok, var userId) {
    this.userId = userId;
    authTocken = tok;
  }

  var showFavoritesOnly = false;
  List<Product> get items {
    return [..._items];
  }

  //   void showAll(){
  //   showFavoritesOnly=false;
  //   notifyListeners();
  // }
  // void showFav(){
  //   showFavoritesOnly=true;
  //   notifyListeners();
  // }
  List<Product> get favoriteItems {
    return _items.where((item) => item.isFav == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> removeProduct(String id) async {
    final url =
        'https://shop-79395.firebaseio.com/products/$id.json?auth=$authTocken';
    final _existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var _existingProduct = _items[_existingProductIndex];
    _items.removeAt(_existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException(
          'can\'t delete the item'); //like return  bt5rog bara el function
    }
    _existingProduct = null;
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-79395.firebaseio.com/products.json?auth=$authTocken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFav,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> fetchProducts([bool filterbyUser = false]) async {
    String filterString =
        filterbyUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shop-79395.firebaseio.com/products.json?auth=$authTocken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-79395.firebaseio.com/userFavorits/$userId.json?auth=$authTocken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((prodId, productData) {
        loadedProducts.add(Product(
          id: prodId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFav: favData == null ? false : favData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    final url =
        'https://shop-79395.firebaseio.com/products/$id.json?auth=$authTocken';
    if (prodIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      // print('...');
    }
  }

  // void editProduct(String productId, Product product) {
  //   final prodIndex = _items.indexWhere((item) {
  //     return item.id == productId;
  //   });
  //   if (prodIndex != null) {
  //     _items[prodIndex] = product;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

}
