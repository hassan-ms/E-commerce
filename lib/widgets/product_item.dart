import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final prouctCart = Provider.of<Cart>(context);
   
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed('/product-details', arguments: product.id);
        },
        child: GridTile(
          child:Hero(
            tag: product.id,
            child:FadeInImage(placeholder: AssetImage('assets/images/product-placeholder.png'), image: NetworkImage(product.imageUrl),fit: BoxFit.cover,)
          ),
          header: Text(product.price.toString()),
          footer: Container(
            height: 40,
            child: GridTileBar(
              title: Text(
                product.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.black87,
              //we use consumer if we don't want all widget to rebuild when somethimg changes only the part of consumer will rebuild
              leading: Consumer<Product>(
                builder: (ctx, product, child) => IconButton(
                    icon: Icon(
                        product.isFav ? Icons.favorite : Icons.favorite_border),
                    onPressed: () {
                      final _authData = Provider.of<Auth>(context);
                      product.toggleFav(_authData.token, _authData.userid);
                    }),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    prouctCart.addItem(
                        product.id, product.price, product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'added successfully',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 2),
                        action: SnackBarAction(
                            label: 'undo',
                            onPressed: () {
                              prouctCart.removeSingleProduct(product.id);
                            }),
                      ),
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
