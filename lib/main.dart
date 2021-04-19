import 'package:flutter/material.dart';
import 'package:shopping/helper/custom_route.dart';
import 'package:shopping/providers/auth.dart';
import 'package:shopping/providers/cart.dart';
import 'package:shopping/providers/orders.dart';
import 'package:shopping/screens/auth_screen.dart';
import 'package:shopping/screens/cart_screen.dart';
import 'package:shopping/screens/edit_product_screen.dart';
import 'package:shopping/screens/orders_screen.dart';
import 'package:shopping/screens/product_detail_screen.dart';
import 'package:shopping/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:shopping/screens/products_overview_screen.dart';
import 'package:shopping/screens/splash_screen.dart';
import 'package:shopping/screens/user_products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: null,
          update: (context, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: null,
          update: (context, auth, previousOrders) => Orders(auth.token,
              auth.userId, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'ShoppingApp',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
                TargetPlatform.android: CustomPageTransitionBuilder()
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
