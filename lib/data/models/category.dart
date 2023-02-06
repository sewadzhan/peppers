import 'package:equatable/equatable.dart';
import 'package:pikapika_admin_panel/data/models/base_product.dart';
import 'package:pikapika_admin_panel/data/models/gift_product.dart';

import 'package:pikapika_admin_panel/data/models/product.dart';

enum CategoryType { usual, gift, none, extraSales, additional }

//Model for product's category
class Category extends Equatable {
  final CategoryType type;
  final String name;
  final List<BaseProduct> products;
  final String categoryID;

  const Category(
      {required this.type,
      required this.name,
      required this.products,
      required this.categoryID});

  @override
  List<Object?> get props => [name, products];

  factory Category.fromMapIiko(
      Map<String, dynamic> group, List<dynamic> products) {
//Retrieving products for certain group and sort by order number
    var groupProducts = products
        .where((element) => element['parentGroup'] == group['id'])
        .toList();
    groupProducts.sort(((a, b) => a['order'].compareTo(b['order'])));

    //Check for gift category using tags
    var groupTags = group['tags'] != null ? List.from(group['tags']) : [];
    if (groupTags.contains('gift')) {
      return Category(
          type: CategoryType.gift,
          name: group['seoTitle'].toString(),
          products: groupProducts
              .map((e) => GiftProduct.fromMapIiko(e, group))
              .toList(),
          categoryID: group['id']);
    } else if (groupTags.contains('extraSales')) {
      return Category(
          type: CategoryType.extraSales,
          name: group['seoTitle'].toString(),
          products:
              groupProducts.map((e) => Product.fromMapIiko(e, group)).toList(),
          categoryID: group['id']);
    }
    //Category for additional set profuct (extra wasabi or ginger or cutlery)
    else if (groupTags.contains('additional')) {
      return Category(
          type: CategoryType.additional,
          name: group['seoTitle'].toString(),
          products:
              groupProducts.map((e) => Product.fromMapIiko(e, group)).toList(),
          categoryID: group['id']);
    } else {
      return Category(
          type: CategoryType.usual,
          name: group['seoTitle'].toString(),
          products:
              groupProducts.map((e) => Product.fromMapIiko(e, group)).toList(),
          categoryID: group['id']);
    }
  }

  factory Category.fromMapFirestore(Map<String, dynamic> categoryMap,
      List<Map<String, dynamic>> productsMap) {
    CategoryType type;
    List<BaseProduct> products;
    switch (categoryMap['type']) {
      case "usual":
        type = CategoryType.usual;
        products = <Product>[];
        for (int i = 0; i < productsMap.length; i++) {
          try {
            products.add(Product.fromMapFirestore(productsMap[i]));
          } catch (e) {
            print("Product converting from map to Product failed $e");
          }
        }
        break;
      case "gift":
        type = CategoryType.gift;
        products = <GiftProduct>[];
        for (int i = 0; i < productsMap.length; i++) {
          try {
            products.add(GiftProduct.fromMapFirestore(productsMap[i]));
          } catch (e) {
            print("GiftProduct converting from map to GiftProduct failed $e");
          }
        }
        break;
      default:
        type = CategoryType.none;
        products = [];
    }
    return Category(
      categoryID: categoryMap['categoryID'] ?? '',
      type: type,
      name: categoryMap['name'] ?? '',
      products: products,
    );
  }
}
