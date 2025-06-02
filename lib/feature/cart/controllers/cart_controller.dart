import 'package:shoppingmalls/feature/order/models/order.dart';

import '../models/cart_item.dart';

class CartController {
  List<CartItem> cart;
  List<Order> orders;

  CartController({required this.cart, required this.orders});

  void increaseQuantity(int index) {
    cart[index].quantity++;
  }

  void decreaseQuantity(int index) {
    if (cart[index].quantity > 1) {
      cart[index].quantity--;
    } else {
      cart.removeAt(index);
    }
  }

  void checkout() {
    if (cart.isEmpty) return;

    orders.add(Order(items: cart.map((item) => item.copy()).toList(), orderedAt: DateTime.now()));
    cart.clear();
  }
}
