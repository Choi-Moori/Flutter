import 'package:flutter/material.dart';
import '../models/product.dart';
import '../controllers/shopping_controller.dart';
import '../../cart/models/cart_item.dart';
import '../../../core/constants/product_category.dart';


class ShoppingScreen extends StatefulWidget {
  final List<Product> products;
  final List<CartItem> cart;

  const ShoppingScreen({required this.products, required this.cart, super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  late ShoppingController controller;
  String _searchQuery = '';
  ProductCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    controller = ShoppingController(products: widget.products, cart: widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = controller.filterProducts(_searchQuery, _selectedCategory);

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
                    onPressed: () {
                      setState(() {
                        controller.addToCart(product);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name}이(가) 장바구니에 담겼습니다')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    final categories = ProductCategory.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          final text = controller.categoryToKorean(category);
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
}
