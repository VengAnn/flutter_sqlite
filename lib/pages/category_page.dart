// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_sqlite/components/dialog_cmp.dart';
import 'package:flutter_sqlite/components/my_text.dart';
import 'package:flutter_sqlite/hepler/dao/category_dao.dart';
import 'package:flutter_sqlite/models/category_model.dart';

import '../components/snack_bar.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryDAO _categoryDAO = CategoryDAO();
  List<CategoryModel> categoriesGl = [];
  final TextEditingController _cateogryName = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadCategory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadCategory() async {
    await _categoryDAO.getAllCategories().then((value) {
      setState(() {
        categoriesGl = value;
      });
    });
  }

  void dialogAddEditCategory(
    BuildContext context,
    double size, {
    bool edit = false,
    CategoryModel? category,
  }) {
    if (edit && category != null) {
      _cateogryName.text = category.name;
    } else {
      _cateogryName.clear();
    }

    DialogCmp.showCustomDialog(
      context: context,
      title: MyText.title(edit ? 'Edit Category' : 'Add Category'),
      content: SizedBox(
        height: size,
        child: Column(
          children: [
            TextFormField(
              controller: _cateogryName,
              decoration: InputDecoration(labelText: "Category Name"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final name = _cateogryName.text.trim();
                if (name.isEmpty) {
                  SnackBarCmp.show(
                    message: 'Please enter a category name',
                    context: context,
                  );
                  return;
                }

                if (edit) {
                  final updatedCate = CategoryModel(
                    id: category!.id,
                    name: name,
                  );

                  final value = await _categoryDAO.updateCategory(updatedCate);
                  if (value > 0) {
                    _loadCategory();

                    Navigator.pop(context, true);
                    SnackBarCmp.show(
                      message: 'Category updated successfully',
                      context: context,
                    );
                  }
                } else {
                  final newCate = CategoryModel(name: name);
                  final value = await _categoryDAO.insertCategory(newCate);
                  if (value > 0) {
                    _loadCategory();

                    Navigator.pop(context, true);
                    SnackBarCmp.show(
                      message: 'Category added successfully',
                      context: context,
                    );
                  }
                }
              },
              child: Icon(edit ? Icons.edit : Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(int id) {
    DialogCmp.showConfirmDialog(
      context: context,
      title: MyText.title('Delete Category'),
      content: const Text('Are you sure you want to delete this category?'),
      onConfirm: () async {
        final deleted = await _categoryDAO.deleteCategory(id);
        if (deleted > 0) {
          _loadCategory(); // Refresh UI
          SnackBarCmp.show(context: context, message: 'Deleted successfully');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text("Category Page"),
        actions: [
          IconButton(
            onPressed: () {
              _loadCategory();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: categoriesGl.length,
        itemBuilder: (context, index) {
          final category = categoriesGl[index];
          final newIndex = index + 1;

          return ListTile(
            leading: CircleAvatar(child: MyText.body(newIndex.toString())),
            title: MyText.body(category.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // debugPrint('edit id: ${category.id}');

                    dialogAddEditCategory(
                      context,
                      size.height * 0.15,
                      edit: true,
                      category: CategoryModel(
                        id: category.id,
                        name: category.name,
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    // debugPrint('delete id: ${category.id}');
                    _deleteCategory(category.id!);
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // dialog add cateogry
          dialogAddEditCategory(context, size.height * 0.15);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
