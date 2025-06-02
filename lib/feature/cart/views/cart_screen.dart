import 'package:flutter/material.dart';
import 'package:shoppingmalls/feature/order/models/order.dart';
import '../models/cart_item.dart';
import '../controllers/cart_controller.dart';
import '../../../core/constants/product_category.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final List<Order> orders;

  const CartScreen({required this.cart, required this.orders, super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartController controller;

  @override
  void initState() {
    super.initState();
    controller = CartController(cart: widget.cart, orders: widget.orders);
  }

  void _checkout() {
    setState(() {
      controller.checkout();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('구매가 완료되었습니다.')));
  }

  void _increase(int index) {
    setState(() {
      controller.increaseQuantity(index);
    });
  }

  void _decrease(int index) {
    setState(() {
      controller.decreaseQuantity(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.cart.isEmpty) {
      return Center(child: Text('장바구니가 비어있습니다.'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Table(
            border: TableBorder.all(color: Colors.grey.shade300),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey.shade200),
                children: [
                  Padding(padding: EdgeInsets.all(8), child: Text('제품명', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('카테고리', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('제품 가격', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('총 가격', style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(padding: EdgeInsets.all(8), child: Text('개수', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              ...controller.cart.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return TableRow(
                  children: [
                    Padding(padding: EdgeInsets.all(8), child: Text(item.name)),
                    Padding(padding: EdgeInsets.all(8), child: Text(categoryToKorean(item.category))),
                    Padding(padding: EdgeInsets.all(8), child: Text('${item.price}원')),
                    Padding(padding: EdgeInsets.all(8), child: Text('${item.totalPrice}원')),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => _decrease(index)),
                          Text('${item.quantity}'),
                          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => _increase(index)),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _checkout,
            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
            child: Text('구매하기', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}