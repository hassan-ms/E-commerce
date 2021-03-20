import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/flex_space.dart';
import '../widgets/products_grid_view.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';

enum filterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isFavourite = false;
  bool _isinit=false;
  var _isloading = false;
  @override
  void didChangeDependencies() async {
    setState(() {
       _isloading = true;
    });
    if(!_isinit)
    try {
      await Provider.of<Products>(context,listen: false).fetchProducts();
    } catch (e) {

    }
    _isinit=true;
     setState(() {
        _isloading = false;
     });
    super.didChangeDependencies();
  }
  @override
  // void initState()async{
  //   setState(() {
  //      _isloading = true;
  //   });
  //   try {
  //     await Provider.of<Products>(context,listen: false).fetchProducts();
  //   } catch (e) {
  //     print('error internet connection');
  //   }
    
  //    setState(() {
  //       _isloading = false;
  //    });
  //   super.initState();
  // }
  // @override
  // void didChangeDependencies() {
  //   if(_isinit){
  //     Provider.of<Products>(context).fetchProducts();
  //   }
  //   _isinit=false;
  //   super.didChangeDependencies();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace:FlexSpace(),
        title: Text('products'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('only favorites'),
                value: filterOptions.favorites,
              ),
              PopupMenuItem(child: Text('show all'), value: filterOptions.all),
              
            ],
            onSelected: (selecteval) {
              setState(() {
                if (selecteval == filterOptions.favorites) {
                  isFavourite = true;
                } else {
                  isFavourite = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(child: ch, value: cart.itemCount.toString()),
            child:
                IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {
                  Navigator.of(context).pushNamed('/cart');
                  
                }), // will not rebuild
          )
        ],
        
      ),
      drawer:AppDrawer(),
      body:_isloading?Center(child:CircularProgressIndicator()):ProuctsGridView(isFavourite),
      
    );
    
  }
}
