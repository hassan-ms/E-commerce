import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/flex_space.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    var children2 = <Widget>[
      Text(
        'Total ',
        style: TextStyle(
          fontSize: 20,
        ),
      ),
      Spacer(),
      Chip(
        label: Text(
          '\$${cart.totalAmount.toStringAsFixed(2)}',
          style:
              TextStyle(color: Theme.of(context).primaryTextTheme.title.color),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      OrderButton(cart: cart),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        flexibleSpace: FlexSpace(),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: children2,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                productId: cart.items.keys.toList()[i],
                id: cart.items.values.toList()[i].id,
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                price: cart.items.values.toList()[i].price),
            itemCount: cart.itemCount,
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount == 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                     widget.cart.clearCart();
              } catch (e) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                    content:  Text('check your connection',textAlign: TextAlign.center,)));
              }

              setState(() {
                _isLoading = false;
              });
             
            },
      child: _isLoading
          ? CircularProgressIndicator(
              strokeWidth: 2,
            )
          : Text(
              'Order Now',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
