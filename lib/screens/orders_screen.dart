import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/orders.dart' show Orders;
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (context, index) => OrderItem(
          ordersData.orders[index],
        ),
      ),
    );
  }
}
