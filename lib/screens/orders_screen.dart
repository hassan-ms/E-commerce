import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/flex_space.dart';
import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
          flexibleSpace: FlexSpace(),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).fetchOrders(),
            builder: (ctx, dataSnapshpt) {
              if (dataSnapshpt.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapshpt.error != null) {
                return Center(
                  child: Text('error occures'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                    itemBuilder: ((ctx, index) {
                      return OrderItem(ordersData.orders[index]);
                    }),
                    itemCount: ordersData.orders.length,
                  ),
                );
              }
            }));
  }
}
