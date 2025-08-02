import 'package:flutter/material.dart';
import 'package:flutter_sqlite/components/my_text.dart';
import 'package:flutter_sqlite/models/product_model.dart';
import 'package:flutter_sqlite/pages/category_page.dart';

import '../components/custom_textfield.dart';
import '../components/my_container_one.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(width: size.width * 0.05),
                    Text('Category'),
                    Icon(Icons.add, color: Colors.amberAccent),
                  ],
                ),
              ),
            ),
          ),
        ],
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss the keyboard
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MyContainerOne(
              title: 'Product',
              widget: Column(
                children: [
                  //product name
                  MyRowOne(
                    titleName: 'Product Name',
                    widget: CustomTextField(
                      controller: _productNameController,
                      hideBorder: true,
                      hideLabel: true,
                      hintText: 'Name',
                    ),
                  ),

                  // price
                  MyRowOne(
                    titleName: 'Product Price',
                    widget: CustomTextField(
                      controller: _priceController,
                      hideBorder: true,
                      hideLabel: true,
                      hintText: 'Price',
                    ),
                  ),
                  // category
                  MyRowOne(
                    titleName: 'Category',
                    widget: DropdownButton(
                      hint: Text('Select Category'),
                      items: [
                        DropdownMenuItem(value: 'abc', child: Text('abc')),
                        DropdownMenuItem(value: 'dfg', child: Text('dfg')),
                      ],
                      onChanged: (value) {
                        debugPrint('value drop down: $value');
                      },
                    ),
                  ),
                  // input image url from internet
                  MyRowOne(
                    titleName: 'Image URL',
                    hideDivider: true,
                    widget: Row(
                      children: [
                        CustomTextField(
                          controller: _productNameController,
                          hideBorder: true,
                          hideLabel: true,
                          hintText: 'Image URL',
                        ),
                        // Button to select image from Google
                        IconButton(
                          icon: const Icon(Icons.image_outlined),
                          onPressed: () {
                            debugPrint('Select image from Google');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text("Add Product"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyRowOne extends StatelessWidget {
  final String titleName;
  final Widget? widget;
  final bool hideDivider;

  const MyRowOne({
    required this.titleName,
    required this.widget,
    this.hideDivider = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // title name
            MyText.body(titleName),
            // Widget
            widget ?? const SizedBox.shrink(),
          ],
        ),
        // Divider
        if (!hideDivider)
          Divider(color: Colors.grey[300], thickness: 1, height: 20),
      ],
    );
  }
}
