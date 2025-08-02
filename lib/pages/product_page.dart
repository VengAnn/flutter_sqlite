import 'package:flutter/material.dart';
import 'package:flutter_sqlite/components/snack_bar.dart';
import 'package:flutter_sqlite/models/product_model.dart';

import '../components/animation_loading.dart';
import '../hepler/dao/product_dao.dart';
import '../hepler/file_picker/file_picker_helper.dart';
import 'add_edit_product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductDAO _productDAO = ProductDAO();
  List<ProductModel> _productGl = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    await _productDAO.getAllProductsWithDetails().then((value) {
      setState(() {
        _productGl = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Page Example')),
      body: _isLoading
          ? Center(
              child: AnimatedCircularProgress(),
            )
          : _productGl.isEmpty
          ? const Center(child: Text('No products available'))
          : ListView.builder(
              itemCount: _productGl.length,
              itemBuilder: (context, index) {
                final product = _productGl[index];

                return ExpansionTile(
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        product.imageUrls!.isNotEmpty
                            ? product.imageUrls!.first
                            : 'https://via.placeholder.com/150',
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text('Category: ${product.categoryName}'),
                    const SizedBox(height: 8),
                    const Divider(),
                    Container(
                      color: Colors.blue[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              debugPrint('Edit ${product.name}');
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              debugPrint('Delete ${product.name}');
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Row(
        children: [
          // btn add new product
          FloatingActionButton(
            heroTag: 'addProduct',
            onPressed: () {
              // Navigate to Add/Edit Product Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditProductPage()),
              ).then((value) {
                if (value == true) {
                  _loadProducts();
                }
              });
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),

          // btn to export sqlite db
          FloatingActionButton(
            heroTag: 'exportDB',
            onPressed: () {
              SnackBarCmp.show(context: context, message: 'Export SQLite DB');
            },
            child: const Icon(Icons.save_alt),
          ),
          const SizedBox(width: 10),
          // btn to import sqlite db
          FloatingActionButton(
            heroTag: 'importDB',
            onPressed: () {
              SnackBarCmp.show(context: context, message: 'Import SQLite DB!');
              FilePickerHelper.openFilePicker();
            },
            child: const Icon(Icons.folder),
          ),
        ],
      ),
    );
  }
}
