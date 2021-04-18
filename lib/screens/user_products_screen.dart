import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping/providers/products.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/widgets/app_drawer.dart';
import 'package:shopping/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user-product';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Product'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProduct(context),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: (_, index) => Column(
                children: [
                  UserProductItem(
                      productsData.items[index].id,
                      productsData.items[index].title,
                      productsData.items[index].imageUrl),
                  Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
