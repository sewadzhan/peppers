import 'dart:convert';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:peppers_admin_panel/data/models/cart.dart';
import 'package:peppers_admin_panel/data/models/checkout.dart';
import 'package:peppers_admin_panel/data/models/pikapika_user.dart';

class IikoProvider {
  final String iikoWebLogin = '2e13cc74';
  final String proxyURL =
      'https://us-central1-pikapika-a82c0.cloudfunctions.net/iikoApi';

  Future<Response> getToken() async {
    return await post(
      Uri.parse('$proxyURL/api/access_token'),
      headers: {
        "content-type": "application/json",
      },
      body: jsonEncode({"apiLogin": iikoWebLogin}),
    );
  }

  Future<Response> getOrganization(String token) async {
    return await post(Uri.parse('$proxyURL/api/organizations'),
        headers: {
          "content-type": "application/json",
          "Authorization": token,
        },
        body: jsonEncode({}));
  }

  Future<Response> getDiscounts(String token, String organizationID) async {
    return await post(Uri.parse('$proxyURL/api/discounts'),
        headers: {
          "content-type": "application/json",
          "Authorization": token,
        },
        body: jsonEncode({
          "organizationIds": [organizationID],
          "includeDisabled": false
        }));
  }

  Future<Response> getTerminalGroups(
      String token, String organizationID) async {
    return await post(Uri.parse('$proxyURL/api/terminal_groups'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({
          "organizationIds": [organizationID],
          "includeDisabled": true
        }));
  }

  Future<Response> getOrderTypes(String token, String organizationID) async {
    return await post(Uri.parse('$proxyURL/api/deliveries/order_types'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({
          "organizationIds": [organizationID],
        }));
  }

  Future<Response> getCities(String token, String organizationID) async {
    return await post(Uri.parse('$proxyURL/api/cities'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({
          "organizationIds": [organizationID],
        }));
  }

  Future<Response> getStreets(
      String token, String organizationID, String cityID) async {
    return await post(Uri.parse('$proxyURL/api/streets/by_city'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({
          "organizationId": organizationID,
          "cityId": cityID,
        }));
  }

  Future<Response> getOrdersById(
      String token, String organizationID, String orderID) async {
    return await post(Uri.parse('$proxyURL/api/deliveries/by_id'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({
          "organizationId": organizationID,
          "orderIds": [orderID]
        }));
  }

  Future<Response> checkCorrelationID(
      String token, String correlationID) async {
    return await post(Uri.parse('$proxyURL/api/commands/status'),
        headers: {"content-type": "application/json", "Authorization": token},
        body: jsonEncode({"correlationId": correlationID}));
  }

  Future<Response> getMenu(String token, String organizationID) async {
    return await post(Uri.parse('$proxyURL/api/nomenclature'),
        headers: {"content-type": "application/json", "Authorization": token},
        body:
            jsonEncode({"organizationId": organizationID, "startRevision": 0}));
  }

  Future<Response> createDelivery(
      {required String token,
      required String organizationID,
      required Checkout checkout,
      required PikapikaUser user,
      required Cart cart,
      required String comment,
      required int cashbackUsed,
      required int numberOfPersons}) async {
    //Preparing map for delivery data
    var deliveryPoint = checkout.orderType == OrderType.delivery
        ? {
            "coordinates": {
              "latitude": checkout.address.geopoint.latitude,
              "longitude": checkout.address.geopoint.longitude
            },
            "address": {
              "street": {
                "name": checkout.address.address,
                "city": "Алматы",
              },
              "house": ",",
              "flat": checkout.address.apartmentOrOffice
            },
          }
        : null;

    //Preparing comments data
    var orderComment = checkout.deliveryTime == DeliveryTimeType.fast
        ? "Время доставки: Как можно скорее; "
        : "Время доставки: ${checkout.certainTimeOrder}; ";
    if (comment.isNotEmpty) {
      orderComment += "Доп комментарии: $comment; ";
    }
    if (checkout.paymentMethod == PaymentMethod.cash) {
      orderComment += "Сдача с: ${checkout.changeWith}; ";
    }
    if (checkout.paymentMethod == PaymentMethod.nonCash) {
      orderComment += "Оплата безналичными; ";
    }

    //Preparing payment data
    String paymentTypeKind;
    String paymentTypeId;

    switch (checkout.paymentMethod) {
      case PaymentMethod.cash:
        paymentTypeKind = "Cash";
        paymentTypeId = "09322f46-578a-d210-add7-eec222a08871";
        break;
      case PaymentMethod.nonCash:
        paymentTypeKind = "Cash";
        paymentTypeId = "09322f46-578a-d210-add7-eec222a08871";
        break;
      case PaymentMethod.bankCard:
        paymentTypeKind = "Card";
        paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3";
        break;
      case PaymentMethod.savedBankCard:
        paymentTypeKind = "Card";
        paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3";
        break;
      case PaymentMethod.applePay:
        paymentTypeKind = "Card";
        paymentTypeId = "c2ae5448-ac8a-4f7a-885f-166bf2a9dcf3";
        break;
      default:
        paymentTypeKind = "Cash";
        paymentTypeId = "09322f46-578a-d210-add7-eec222a08871";
    }

    //Preparing discount info
    var discountsInfo = cart.activePromocode != null &&
            cart.activePromocode!.discountID.isNotEmpty
        ? {
            "discounts": [
              {
                "discountTypeId": cart.activePromocode!.discountID,
                "sum": cart.discount,
                "type": "RMS"
              }
            ]
          }
        : null;

    //Using cashback for discount
    if (cashbackUsed < 0) {
      var discountSum = cashbackUsed * -1;
      var orderTotal = checkout.deliveryCost + cart.subtotal;

      //Check if cashback discount is higher than order total
      if ((cashbackUsed * -1) > orderTotal) {
        discountSum = orderTotal;
      }

      discountsInfo = {
        "discounts": [
          {
            "discountTypeId": "6ca6fc0c-99e3-4ddb-8869-f03d642122df",
            "sum": discountSum,
            "type": "RMS"
          }
        ]
      };
      orderComment += "Применены $discountSum накопительных баллов";
    }

    //Preparing items
    var items = cart.items
        .map((e) => {
              "productId": e.product.iikoID,
              "price": e.product.price,
              "type": "Product",
              "amount": e.count
            })
        .toList();

    //Find terminal group
    var terminalResponse = await getTerminalGroups(token, organizationID);
    var terminalGroupId = jsonDecode(terminalResponse.body)['terminalGroups'][0]
        ['items'][0]['id'];

    // var hui = await getStreets(
    //     token, organizationID, "238df2ca-e984-af99-0178-b650a7a69793");
    // log(hui.body);

    //Output of applied promocode in order comments
    if (cart.activePromocode != null) {
      orderComment += " ПРИМЕНЕН ПРОМОКОД: " + cart.activePromocode!.code;
    }

    return await post(
      Uri.parse('$proxyURL/api/deliveries/create'),
      headers: {
        "content-type": "application/json",
        "Authorization": token,
      },
      body: jsonEncode({
        "organizationId": organizationID,
        "terminalGroupId": terminalGroupId,
        "createOrderSettings": {"mode": "Async"},
        "order": {
          "items": items,
          "payments": [
            {
              "paymentTypeKind": paymentTypeKind,
              "sum": "${checkout.deliveryCost + cart.subtotal - cart.discount}",
              "paymentTypeId": paymentTypeId
            }
          ],
          "orderTypeId": checkout.orderType == OrderType.pickup
              ? "5b1508f9-fe5b-d6af-cb8d-043af587d5c2"
              : "76067ea3-356f-eb93-9d14-1fa00d082c4e",
          "phone": user.phoneNumber,
          "comment": orderComment,
          "customer": {
            "name": user.name,
            "email": user.email,
            "comment": " ",
          },
          "guests": {
            "count": numberOfPersons,
          },
          "deliveryPoint": deliveryPoint,
          "discountsInfo": discountsInfo
        }
      }),
    );
  }
}
