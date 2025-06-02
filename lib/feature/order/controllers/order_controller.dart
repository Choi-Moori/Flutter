import '../models/order.dart';
import '../../cart/models/cart_item.dart';

class OrderController {
  final List<Order> orders;

  OrderController(this.orders);

  void addOrder(List<CartItem> cart) {
    if (cart.isEmpty) return;
    final copiedItems = cart.map((item) => item.copy()).toList();
    orders.add(Order(items: copiedItems, orderedAt: DateTime.now()));
    cart.clear();
  }
}