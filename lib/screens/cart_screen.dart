// screens/cart_screen.dart

import 'package:flutter/material.dart';
import '../shoppingmalls.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cart;
  final List<List<CartItem>> orders;

  const CartScreen({required this.cart, required this.orders});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _increaseQuantity(int index) {
    setState(() {
      widget.cart[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (widget.cart[index].quantity > 1) {
        widget.cart[index].quantity--;
      } else {
        widget.cart.removeAt(index);
      }
    });
  }

  void _checkout() {
    if (widget.cart.isEmpty) return;

    setState(() {
      widget.orders.add(widget.cart.map((item) => CartItem(
        name: item.name,
        price: item.price,
        quantity: item.quantity,
        category: item.category,
      )).toList());
      widget.cart.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('구매가 완료되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cart.isEmpty) {
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
              ...widget.cart.asMap().entries.map((entry) {
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
                          IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => _decreaseQuantity(index)),
                          Text('${item.quantity}'),
                          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => _increaseQuantity(index)),
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
