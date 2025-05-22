// screens/shopping_screen.dart

import 'package:flutter/material.dart';
import '../shoppingmalls.dart';

class ShoppingScreen extends StatefulWidget {
  final List<Product> products;
  final List<CartItem> cart;

  const ShoppingScreen({required this.products, required this.cart});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  String _searchQuery = '';
  ProductCategory? _selectedCategory;

  List<Product> get _filteredProducts {
    return widget.products.where((p) {
      final nameMatch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final categoryMatch = categoryToKorean(p.category).contains(_searchQuery);
      final searchMatch = _searchQuery.isEmpty || nameMatch || categoryMatch;
      final categoryFilterMatch = _selectedCategory == null || p.category == _selectedCategory;
      return searchMatch && categoryFilterMatch;
    }).toList();
  }

  void _addToCart(Product product) {
    setState(() {
      final index = widget.cart.indexWhere((item) => item.name == product.name);
      if (index != -1) {
        widget.cart[index].quantity++;
      } else {
        widget.cart.add(CartItem(name: product.name, price: product.price, category: product.category));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼습니다')));
  }

  Widget _buildCategoryFilter() {
    final categories = ProductCategory.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          final text = categoryToKorean(category);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(text, style: TextStyle(fontSize: 14)),
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              selected: isSelected,
              selectedColor: Colors.blue.shade100,
              onSelected: (_) {
                setState(() {
                  _selectedCategory = isSelected ? null : category;
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
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

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    return Column(
      children: [
        _buildCategoryFilter(),
        _buildSearchBar(),
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
}
