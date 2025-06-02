import 'package:flutter/material.dart';
import '../feature/product/views/shopping_screen.dart';
import '../feature/cart/views/cart_screen.dart';
import '../feature/order/views/order_screen.dart';
import '../core/constants/product_category.dart';
import '../feature/cart/models/cart_item.dart';
import '../feature/product/models/product.dart';
import '../feature/order/models/order.dart';


class ShoppingMallApp extends StatefulWidget {
  final VoidCallback onLogout;
  const ShoppingMallApp({super.key, required this.onLogout});

  @override
  State<ShoppingMallApp> createState() => _ShoppingMallAppState();
}

class _ShoppingMallAppState extends State<ShoppingMallApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  final List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(icon: Icon(Icons.home), text: '홈'),
            Tab(icon: Icon(Icons.shopping_cart), text: '장바구니'),
            Tab(icon: Icon(Icons.inventory), text: '내 주문'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Colors.black),
            onSelected: (value) {
              if (value == 'logout') {
                widget.onLogout();
              } else {
                final index = ['home', 'cart', 'orders'].indexOf(value);
                if (index != -1) {
                  _tabController.animateTo(index);
                }
              }
            },
            itemBuilder: (context) => [
              _menuItem('home', Icons.home, '홈'),
              _menuItem('cart', Icons.shopping_cart, '장바구니'),
              _menuItem('orders', Icons.inventory, '내 주문'),
              PopupMenuDivider(),
              _menuItem('logout', Icons.logout, '로그아웃'),
            ],
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ShoppingScreen(products: _products, cart: _cart),
          CartScreen(cart: _cart, orders: _orders),
          OrderScreen(orders: _orders),
        ],
      ),
    );
  }

  PopupMenuItem<String> _menuItem(String value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
