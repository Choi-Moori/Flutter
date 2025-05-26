// shoppingmalls.dart


// 제품 카테고리를 나타내는 enum
enum ProductCategory { outer, top, bottom, shoes }

// 제품을 나타내는 클래스
class Product {
  final String name;
  final int price;
  final ProductCategory category;
  Product({required this.name, required this.price, required this.category});
}

// 장바구니에 담길 제품을 나타내는 클래스
class CartItem {
  final String name;
  final int price;
  final ProductCategory category;
  int quantity;
  CartItem({required this.name, required this.price, required this.category, this.quantity = 1});

  int get totalPrice => price * quantity;
}

String categoryToKorean(ProductCategory category) {
  switch (category) {
    case ProductCategory.outer:
      return '아우터';
    case ProductCategory.top:
      return '상의';
    case ProductCategory.bottom:
      return '하의';
    case ProductCategory.shoes:
      return '신발';
  }
}