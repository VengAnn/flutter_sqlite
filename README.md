✅ Why Create DAO?

| Benefit                            | Explanation                                       |
| ---------------------------------- | ------------------------------------------------- |
| 🔁 Reusability                     | One place for insert, update, delete, query logic |
| 🧼 Clean Code                      | Keeps DB logic out of UI/logic layers             |
| ✅ Easy maintenance                 | Easy to change queries in one spot                |
| 📏 Enforces separation of concerns | Models = data, DAO = DB logic, UI = presentation  |
| 🧪 Easier testing                  | You can mock or unit test DAO separately          |



# Clean for large project 
lib/
├── main.dart
├── core/
│   ├── utils/
│   │   └── date_formatter.dart      ← custom date formatters
│   └── constants/
│       └── db_constants.dart        ← table names, column names
│
├── data/
│   ├── local/
│   │   ├── sqlite_helper.dart       ← handles DB initialization
│   │   ├── dao/
│   │   │   ├── category_dao.dart
│   │   │   ├── product_dao.dart
│   │   │   └── product_image_dao.dart
│   │   └── models/
│   │       ├── category_model.dart
│   │       ├── product_model.dart
│   │       └── product_image_model.dart
│   └── repository/
│       ├── category_repository.dart
│       ├── product_repository.dart
│       └── product_image_repository.dart
│
├── domain/
│   ├── entities/
│   │   ├── category.dart
│   │   ├── product.dart
│   │   └── product_image.dart
│   └── usecases/
│       ├── get_all_products.dart
│       └── insert_category.dart
│
├── presentation/
│   ├── pages/
│   │   ├── category/
│   │   │   └── category_page.dart
│   │   └── product/
│   │       └── product_page.dart
│   └── widgets/
│       ├── product_tile.dart
│       └── category_form.dart
│
└── providers/ or bloc/
    └── category_provider.dart       ← state management
