import 'package:peppers_admin_panel/data/models/base_product.dart';
import 'package:peppers_admin_panel/data/models/product_feature.dart';
import 'package:peppers_admin_panel/data/models/simple_modifier.dart';
import 'package:peppers_admin_panel/presentation/config/config.dart';

enum ProductTags { hit, discount, latest, none }

//Model for restaurant's products
class Product extends BaseProduct {
  final String description;
  final ProductTags tag;
  final List<ProductFeature> features;
  final int order;
  final String gift;
  final List<SimpleModifier> simpleModifiers;

  const Product(
      {required categoryID,
      required title,
      required imageUrl,
      required price,
      required iikoID,
      required this.description,
      required this.features,
      this.tag = ProductTags.none,
      this.order = 9999,
      this.gift = '',
      this.simpleModifiers = const []})
      : super(
            categoryID: categoryID,
            title: title,
            imageUrl: imageUrl,
            iikoID: iikoID,
            price: price);

  @override
  List<Object> get props => [imageUrl, title, price, categoryID];

  factory Product.fromMapIiko(
      Map<String, dynamic> e, Map<String, dynamic> group) {
    List<dynamic> imageLinks = e['imageLinks'] ?? [];
    double price = List.from(e['sizePrices']).isNotEmpty
        ? e['sizePrices'][0]['price']['currentPrice']
        : 100000;
    List<dynamic> tags = e['tags'] ?? [];
    ProductTags productTag = Config.stringToTag(e['seoTitle'] ?? '');

    return Product(
        categoryID: group['id'],
        title: e['name'],
        imageUrl: imageLinks.isEmpty ? "" : imageLinks[0],
        price: price.toInt(),
        iikoID: e['id'],
        description: e['description'],
        gift: e['additionalInfo'] ?? '',
        tag: productTag,
        features: tags.map((e) {
          var tmp = e.toString().split('=');
          return ProductFeature(
              tmp[0].trim(), tmp.length > 1 ? tmp[1].trim() : '');
        }).toList());
  }

  factory Product.fromMapFirestore(Map<String, dynamic> map) {
    ProductTags tag = Config.stringToTag(map['tag']);
    List<ProductFeature> features = [];

    if (map['features'] != null) {
      Map<String, String> data = Map<String, String>.from(map['features']);
      data.forEach((key, value) => features.add(ProductFeature(key, value)));
    }

    return Product(
        categoryID: map['categoryID'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        title: map['title'] ?? '',
        price: map['price'] ?? '',
        description: map['description'] ?? '',
        tag: tag,
        iikoID: map['iikoID'] ?? '',
        features: features,
        order: map['order'] ?? 9999);
  }

  @override
  String toString() {
    return "$title $price $tag $imageUrl";
  }
}
