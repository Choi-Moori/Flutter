import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter 쇼핑몰', home: ShoppingMallApp());
  }
}

class ShoppingMallApp extends StatefulWidget {
  @override
  _ShoppingMallAppState createState() => _ShoppingMallAppState();
}

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
  CartItem({required this.name, required this.price, required this.category ,this.quantity = 1});

  int get totalPrice => price * quantity;
}

class _ShoppingMallAppState extends State<ShoppingMallApp> {
  int _currentIndex = 0;

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

// 장바구니에 담긴 제품을 저장하는 리스트
  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(name: product.name, category: product.category ,price: product.price));
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼습니다')));
  }

// 장바구니에서 제품 수량을 증가시키는 메서드
  void _increaseQuantity(int index) {
    setState(() {
      _cart[index].quantity++;
    });
  }

// 장바구니에서 제품 수량을 감소시키는 메서드
  void _decreaseQuantity(int index) {
    setState(() {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
    });
  }

  List<Product> get _filteredProducts {
    return _products.where((p) {
      final nameMatch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final categoryMatch = categoryToKorean(p.category).contains(_searchQuery);

      final searchMatch = _searchQuery.isEmpty || nameMatch || categoryMatch;
      final categoryFilterMatch = _selectedCategory == null || p.category == _selectedCategory;

      return searchMatch && categoryFilterMatch;
    }).toList();
  }

// 홈 화면을 출력하는 위젯젯
  Widget _buildHomeScreen() {
    final filtered = _filteredProducts;

    return Column(
      children: [
        _buildCategoryFilter(),
        _buildSearchBar(), // 검색창 위젯
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (ctx, index) {
              final product = filtered[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text('${product.price}원'),
                  trailing: ElevatedButton(
                    child: Text('담기'),
                    onPressed: () => _addToCart(product),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


// 장바구니에서 제품을 구매하는 메서드
  void _checkout() {
    if (_cart.isEmpty) return;

    setState(() {
      _orders.add(
        _cart
            .map(
              (item) => CartItem(
                name: item.name,
                price: item.price,
                quantity: item.quantity,
                category: item.category,
              ),
            )
            .toList(),
      );
      _cart.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('구매가 완료되었습니다.')));
  }

// 장바구니 화면을 출력하는 위젯
  Widget _buildCartScreen() {
    if (_cart.isEmpty) {
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
              ..._cart.asMap().entries.map((entry) {
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


  List<List<CartItem>> _orders = []; //주문 내역 리스트트

// 주문 내역을 출력하는 위젯
  Widget _buildOrdersScreen() {
    if (_orders.isEmpty) {
      return Center(child: Text('주문 내역이 없습니다.'));
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: _orders.length,
      itemBuilder: (context, orderIndex) {
        final order = _orders[orderIndex];
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
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('제품명',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('카테고리리',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('제품 가격',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('총 가격',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('개수',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ...order.map((item) {
                  return TableRow(
                    children: [
                      Padding(padding: EdgeInsets.all(8), child: Text(item.name)),
                      Padding(padding: EdgeInsets.all(8), child: Text(categoryToKorean(item.category))),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('${item.price}원')),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('${item.totalPrice}원')),
                      Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('${item.quantity}')),
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



// 탭바를 사용하여 홈, 장바구니, 주문 내역 화면을 전환하는 메서드
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          title: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // ✅ 세로 기준선 맞춤
              children: [
                Row(
                  children: [
                    Icon(Icons.storefront, color: Colors.black),
                    SizedBox(width: 8),
                    Text('Flutter 쇼핑몰', style: TextStyle(color: Colors.black)),
                  ],
                ),
                Container(
                  child: TabBar(
                    isScrollable: true,
                    indicator: BoxDecoration(),
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(horizontal: 30),
                    labelColor: Colors.purple,
                    unselectedLabelColor: Colors.black,
                    tabs: [
                      Tab(icon: Icon(Icons.home, size: 18), text: '홈'),
                      Tab(
                        icon: Icon(Icons.shopping_cart, size: 18),
                        text: '장바구니',
                      ),
                      Tab(icon: Icon(Icons.inventory, size: 18), text: '내 주문'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: TabBarView(
          children: [
            _buildHomeScreen(),
            _buildCartScreen(),
            _buildOrdersScreen(),
          ],
        ),
      ),
    );
  }

// 제품 카테고리를 한국어로 변환하는 메서드
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

  String _searchQuery = '';

  Widget _buildSearchBar(){
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
          hintText: '제품명 또는 카테고리명으로 검색',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.trim();
          });
        },
      ),
    );
  }

  ProductCategory ? _selectedCategory;

  Widget _buildCategoryFilter() {
    final categories = ProductCategory.values;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          final text = categoryToKorean(category);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                text,
                style: TextStyle(fontSize: 14),        // 글자 크기 조정
                overflow: TextOverflow.visible,        // 글자 자르지 않음
                softWrap: false,                       // 자동 줄바꿈 안 함
              ),
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              selected: isSelected,
              selectedColor: Colors.blue.shade100,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = isSelected ? null : category;
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            ),
          );
        }).toList(),
      ),
    );
  }

}
