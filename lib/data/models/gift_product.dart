import 'package:pikapika_admin_panel/data/models/base_product.dart';
import 'package:pikapika_admin_panel/data/models/product_feature.dart';

//Product for free gift
class GiftProduct extends BaseProduct {
  final List<ProductFeature> features;

  const GiftProduct({
    required categoryID,
    required title,
    required imageUrl,
    required iikoID,
    required this.features,
  }) : super(
            categoryID: categoryID,
            title: title,
            imageUrl: imageUrl,
            iikoID: iikoID,
            price: 0);

  @override
  List<Object> get props => [imageUrl, title, price, categoryID];

  factory GiftProduct.fromMapIiko(
      Map<String, dynamic> e, Map<String, dynamic> group) {
    List<dynamic> imageLinks = e['imageLinks'];
    List<dynamic> tags = e['tags'];
    return GiftProduct(
        categoryID: group['id'],
        title: e['name'],
        imageUrl: imageLinks.isEmpty ? "" : imageLinks[0],
        iikoID: e['id'],
        features: tags.map((e) {
          var tmp = e.toString().replaceAll(' ', '').split('=');
          return ProductFeature(tmp[0], tmp.length > 1 ? tmp[1] : '');
        }).toList());
  }

  factory GiftProduct.fromMapFirestore(Map<String, dynamic> map) {
    List<ProductFeature> features = [];

    if (map['features'] != null) {
      Map<String, String> data = Map<String, String>.from(map['features']);
      data.forEach((key, value) => features.add(ProductFeature(key, value)));
    }

    return GiftProduct(
        categoryID: map['categoryID'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        title: map['title'] ?? '',
        iikoID: map['iikoID'] ?? '',
        features: features);
  }

  @override
  String toString() {
    return "Gift product $title $price $imageUrl";
  }
}
