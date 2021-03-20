import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/flex_space.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  Future<void> _refresh(BuildContext context) {
    return Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final userProducts = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexSpace(),
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-product');
              })
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(        //to rebuild this part only the same as didchangdep in statefull
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<Products>(
                      builder: (ctx, userProducts, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: <Widget>[
                              UserProductItem(
                                  userProducts.items[index].id,
                                  userProducts.items[index].title,
                                  userProducts.items[index].imageUrl),
                              Divider(),
                            ],
                          ),
                          itemCount: userProducts.items.length,
                        ),
                      ),
                    ),
                    onRefresh: () => _refresh(context),
                  ),
        future: _refresh(context),
      ),
    );
  }
}
