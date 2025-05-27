// main.dart

import 'package:flutter/material.dart';
import 'login.dart';
import 'shoppingmalls.dart';
import 'screens/shopping_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  void _handleLogin(String id, String pw) {
    if (id == 'admin' && pw == '1234') {
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: Text('로그인 실패'),
          content: Text('아이디 또는 비밀번호가 틀렸습니다.\n id : admin \n pw : 1234'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  void _handledLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 쇼핑몰',
      navigatorKey: navigatorKey,
      home: _isLoggedIn
          ? ShoppingMallApp(onLogout: _handledLogout)
          : LoginScreen(onLogin: _handleLogin),
    );
  }
}

class ShoppingMallApp extends StatefulWidget {
  final VoidCallback onLogout;
  const ShoppingMallApp({required this.onLogout});

  @override
  _ShoppingMallAppState createState() => _ShoppingMallAppState();
}

class _ShoppingMallAppState extends State<ShoppingMallApp> {
  final List<Product> _products = [
    Product(name: '후드 집업', price: 45000, category: ProductCategory.outer),
    Product(name: '가죽 재킷', price: 85000, category: ProductCategory.outer),
    Product(name: '반팔 티셔츠', price: 15000, category: ProductCategory.top),
    Product(name: '니트 스웨터', price: 30000, category: ProductCategory.top),
    Product(name: '청바지', price: 40000, category: ProductCategory.bottom),
    Product(name: '슬랙스', price: 35000, category: ProductCategory.bottom),
    Product(name: '운동화', price: 60000, category: ProductCategory.shoes),
    Product(name: '샌들', price: 28000, category: ProductCategory.shoes),
  ];

  final List<CartItem> _cart = [];
  final List<List<CartItem>> _orders = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Row(
            children: [
              Icon(Icons.storefront, color: Colors.black),
              SizedBox(width: 8),
              Text('Flutter 쇼핑몰', style: TextStyle(color: Colors.black)),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.menu, color: Colors.black),
              onSelected: (value) {
                if (value == 'logout') {
                  widget.onLogout();
                } else {
                  DefaultTabController.of(context).animateTo(
                    ['home', 'cart', 'orders'].indexOf(value),
                  );
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'home',
                  child: Row(
                    children: [
                      Icon(Icons.home, color: Colors.black),
                      SizedBox(width: 8),
                      Text('홈'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'cart',
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.black),
                      SizedBox(width: 8),
                      Text('장바구니'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'orders',
                  child: Row(
                    children: [
                      Icon(Icons.inventory, color: Colors.black),
                      SizedBox(width: 8),
                      Text('내 주문'),
                    ],
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 8),
                      Text('로그아웃'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: TabBarView(
          children: [
            ShoppingScreen(products: _products, cart: _cart),
            CartScreen(cart: _cart, orders: _orders),
            OrderScreen(orders: _orders),
          ],
        ),
      ),
    );
  }
}
