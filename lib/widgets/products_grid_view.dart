import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/products.dart';

class ProuctsGridView extends StatelessWidget {
  final isFavourite;
  ProuctsGridView(this.isFavourite);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =isFavourite?productsData.favoriteItems:productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10), 
      itemBuilder: ((ctx, index) => ChangeNotifierProvider.value(
            // builder: (c)=>   //if we don't have to use context can use value
            value: products[index],
            child: ProductItem(),
          )),
      itemCount: products.length,
    );
  }
}
