// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/components/custom_textfield.dart';
import 'package:flutter_sqlite/components/my_container_one.dart';
import 'package:flutter_sqlite/components/snack_bar.dart';
import 'package:flutter_sqlite/hepler/dao/category_dao.dart';
import 'package:flutter_sqlite/hepler/dao/product_dao.dart';
import 'package:flutter_sqlite/hepler/dao/product_image_dao.dart';
import 'package:flutter_sqlite/models/category_model.dart';
import 'package:flutter_sqlite/models/product_image_model.dart';
import 'package:flutter_sqlite/models/product_model.dart';
import 'package:flutter_sqlite/pages/category_page.dart';
import '../widgets/my_row_one.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imgUrlController = TextEditingController();

  final CategoryDAO _categoryDAO = CategoryDAO();
  final ProductDAO _productDAO = ProductDAO();
  final ProductImageDAO _imageDAO = ProductImageDAO();

  List<CategoryModel> categories = [];
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadAllCategories();

    if (widget.product != null) {
      debugPrint("product is : ${widget.product?.idImg}");
      _loadDefaultForEditProduct();
    }
  }

  void _loadAllCategories() async {
    final result = await _categoryDAO.getAllCategories();
    setState(() {
      categories = result;
      if (widget.product != null) {
        _selectedCategoryId = widget.product!.categoryId;
      }
    });
  }

  void _loadDefaultForEditProduct() {
    _productNameController.text = widget.product!.name;
    _priceController.text = widget.product!.price.toString();
    _imgUrlController.text = widget.product!.imgUrl.toString();
    _selectedCategoryId = widget.product!.categoryId;
  }

  void _insertEditProduct(ProductModel product) async {
    if (widget.product == null) {
      final valuePro = await _productDAO.insertProduct(product);
      final proImg = ProductImageModel(
        productId: valuePro,
        imageUrl: product.imgUrl.toString(),
      );
      final valueProImg = await insertImgProduct(proImg);

      debugPrint('insert is: $valueProImg-- $valuePro');
      if (valuePro > 0 && valueProImg) {
        Navigator.pop(context, true);
        SnackBarCmp.show(
          message: 'Product added successfully!',
          context: context,
        );
      }
    } else {
      final valuePro = await _productDAO.updateProduct(product);
      final proImgEdit = ProductImageModel(
        id: widget.product!.idImg,
        productId: product.id!,
        imageUrl: product.imgUrl.toString(),
      );
      final valueProImg = await insertImgProduct(proImgEdit);

      debugPrint(' update is: $valueProImg-- $valuePro');

      if (valuePro > 0 && valueProImg) {
        Navigator.pop(context, true);
        SnackBarCmp.show(
          message: 'Product updated successfully!',
          context: context,
        );
      }
    }
  }

  Future<bool> insertImgProduct(ProductImageModel productImg) async {
    debugPrint("img id: ${productImg.id}");

    if (widget.product == null) {
      final result = await _imageDAO.insertImage(productImg);
      return result > 0;
    } else {
      final result = await _imageDAO.updateImage(productImg);
      return result > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                );

                if (result == true) _loadAllCategories();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: size.width * 0.05),
                    const Text('Category'),
                    const Icon(Icons.add, color: Colors.amberAccent),
                  ],
                ),
              ),
            ),
          ),
        ],
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyContainerOne(
                title: 'Product',
                widget: Column(
                  children: [
                    MyRowOne(
                      titleName: 'Product Name',
                      widget: CustomTextField(
                        controller: _productNameController,
                        hideBorder: true,
                        hideLabel: true,
                        hintText: 'Name',
                      ),
                    ),
                    MyRowOne(
                      titleName: 'Product Price',
                      widget: CustomTextField(
                        controller: _priceController,
                        hideBorder: true,
                        hideLabel: true,
                        hintText: 'Price',
                      ),
                    ),
                    MyRowOne(
                      titleName: 'Category',
                      widget: DropdownButton<int>(
                        value: _selectedCategoryId,
                        isExpanded: false,
                        underline: SizedBox(),
                        hint: Text("Select Category"),
                        items: categories.map((e) {
                          return DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                      ),
                    ),

                    MyRowOne(
                      titleName: 'Image URL',
                      hideDivider: true,
                      widget: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _imgUrlController,
                                hideBorder: true,
                                hideLabel: true,
                                hintText: 'Image URL',
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.image_outlined),
                              onPressed: () =>
                                  debugPrint('Select image from Google'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () async {
                          final name = _productNameController.text.trim();
                          final price = double.tryParse(
                            _priceController.text.trim(),
                          );
                          final imgUrl = _imgUrlController.text.trim();

                          if (_selectedCategoryId == null) {
                            SnackBarCmp.show(
                              message: 'Please select a category.',
                              context: context,
                            );
                            return;
                          }
                          if (name.isEmpty) {
                            SnackBarCmp.show(
                              message: 'Product name cannot be empty.',
                              context: context,
                            );
                            return;
                          }
                          if (price == null || price <= 0) {
                            SnackBarCmp.show(
                              message: "Please enter a valid price.",
                              context: context,
                            );
                            return;
                          }
                          if (imgUrl.isEmpty) {
                            SnackBarCmp.show(
                              message: "Please input img URL",
                              context: context,
                            );
                            return;
                          }

                          final newProduct = ProductModel(
                            id: widget.product?.id,
                            categoryId: _selectedCategoryId!,
                            name: name,
                            price: price,
                            imgUrl: imgUrl,
                          );

                          _insertEditProduct(newProduct);

                          _productNameController.clear();
                          _priceController.clear();
                          _imgUrlController.clear();
                          setState(() => _selectedCategoryId = null);
                        },
                        child: Text(
                          widget.product == null
                              ? 'Add Product'
                              : 'Edit Product',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
