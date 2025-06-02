import 'package:flutter/material.dart';
import '../models/order.dart';
import '../../../core/constants/product_category.dart';



class OrderScreen extends StatelessWidget {
  final List<Order> orders;

  const OrderScreen({required this.orders, super.key});

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('주문 ${orderIndex + 1} - ${_formatDate(order.orderedAt)}',
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
                    _header('제품명'),
                    _header('카테고리'),
                    _header('제품 가격'),
                    _header('총 가격'),
                    _header('개수'),
                  ],
                ),
                ...order.items.map((item) {
                  return TableRow(
                    children: [
                      _cell(item.name),
                      _cell(categoryToKorean(item.category)),
                      _cell('${item.price}원'),
                      _cell('${item.totalPrice}원'),
                      _cell('${item.quantity}'),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '총 주문 금액: ${order.totalPrice}원',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _header(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _cell(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(text),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
