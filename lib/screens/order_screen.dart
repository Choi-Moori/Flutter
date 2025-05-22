// screens/order_screen.dart

import 'package:flutter/material.dart';
import '../shoppingmalls.dart';

class OrderScreen extends StatelessWidget {
  final List<List<CartItem>> orders;

  const OrderScreen({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(child: Text('주문 내역이 없습니다.'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, orderIndex) {
        final order = orders[orderIndex];
        final totalOrderPrice = order.fold(0, (sum, item) => sum + item.totalPrice);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주문 ${orderIndex + 1}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
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
                ...order.map((item) {
                  return TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8), child: Text(item.name)),
                      Padding(padding: EdgeInsets.all(8), child: Text(categoryToKorean(item.category))),
                      Padding(padding: EdgeInsets.all(8), child: Text('${item.price}원')),
                      Padding(padding: EdgeInsets.all(8), child: Text('${item.totalPrice}원')),
                      Padding(padding: EdgeInsets.all(8), child: Text('${item.quantity}')),
                    ],
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '총 주문 금액: ${totalOrderPrice}원',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
