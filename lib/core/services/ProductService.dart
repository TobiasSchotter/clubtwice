import 'package:clubtwice/core/model/Product.dart';

class ProductService {
  static List<Product> productData =
      productRawData.map((data) => Product.fromJson(data)).toList();
  static List<Product> searchedProductData =
      searchedProductRawData.map((data) => Product.fromJson(data)).toList();
}

var productRawData = [
  {
    'image': [
      'assets/images/nikeblack.jpg',
      'assets/images/nikegrey.jpg',
    ],
    'name': 'Nike Waffle One',
    'price': 1429000,
    'description':
        'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
    'store_name': 'Nike Indonesia',
  },
];

var searchedProductRawData = [
  {
    'image': [
      'assets/images/search/searchitem6.jpg',
      'assets/images/nikegrey.jpg',
    ],
    'name': 'Air Jordan XXXVI SE PF',
    'price': 2729000,
    'description':
        'Bringing a new look to the Waffle sneaker family, the Nike Waffle One balances everything you love about heritage Nike running with fresh innovations.',
    'store_name': 'Nike Indonesia',
  },
];
