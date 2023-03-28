import 'dart:convert';

import 'package:peppers_admin_panel/data/models/category.dart';
import 'package:peppers_admin_panel/data/models/iiko_category.dart';
import 'package:peppers_admin_panel/data/models/iiko_discount.dart';
import 'package:peppers_admin_panel/data/models/iiko_organization.dart';
import 'package:peppers_admin_panel/data/providers/iiko_provider.dart';
import 'package:http/http.dart';
import 'package:peppers_admin_panel/presentation/config/pikapika_exception.dart';

class IikoRepository {
  final IikoProvider iikoProvider;

  IikoRepository(this.iikoProvider);

  Future<String> getToken() async {
    Response response = await iikoProvider.getToken();
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return "Bearer ${body['token']}";
    }
    throw PikapikaException("Unable to retrieve token");
  }

  Future<String> getOrganization(String token) async {
    Response response = await iikoProvider.getOrganization(token);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return body['organizations'][0]['id'];
    }
    throw PikapikaException("Unable to retrieve organization ID");
  }

  Future<List<IikoOrganization>> getAllOrganizations(String token) async {
    Response response = await iikoProvider.getOrganization(token);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      List<dynamic> organizations = body['organizations'];
      return organizations.map((e) => IikoOrganization.fromMap(e)).toList();
    }
    throw PikapikaException("Unable to retrieve organization ID");
  }

  Future<List<Category>> getMenu(String token, String organizationID) async {
    Response response = await iikoProvider.getMenu(token, organizationID);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> groups = body['groups'];

      List<dynamic> products = body['products'];

      groups.sort(((a, b) => a['order'].compareTo(b['order'])));

      return groups
          .where((element) =>
              element['parentGroup'] ==
              "5adf4a78-e8d6-43a3-9248-fc46fe42dc47") //Get groups from folder "Mobile app"
          .map((e) => Category.fromMapIiko(e, products))
          .where((element) => element.products.isNotEmpty)
          .toList();
    }
    throw PikapikaException("Unable to retrieve organization ID");
  }

  Future<List<IikoDiscount>> getDiscounts(
      String token, String organizationID) async {
    Response response = await iikoProvider.getDiscounts(token, organizationID);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> discounts = body['discounts'];

      if (discounts.isNotEmpty) {
        List<dynamic> items = discounts.first['items'];
        return items
            .where((element) => element['percent'] > 0)
            .map((e) => IikoDiscount.fromMap(e))
            .toList();
      }
      return [];
    }
    throw PikapikaException("Unable to retrieve organization ID");
  }

  Future<List<IikoCategory>> getCategories(
      String token, String organizationID) async {
    Response response = await iikoProvider.getMenu(token, organizationID);

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<dynamic> groups = body['groups'];

      return groups
          .where((element) =>
              element['parentGroup'] ==
              "5dc35460-b455-4afe-a1e6-f6ec81b40bc7") //Get groups from folder "Mobile app"
          .map((e) => IikoCategory.fromMap(e))
          .toList();
    }
    throw PikapikaException("Unable to retrieve organization ID");
  }
}
