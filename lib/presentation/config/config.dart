import 'package:flutter_paybox/paybox.dart' as paybox;
import 'package:peppers_admin_panel/data/models/checkout.dart';
import 'package:peppers_admin_panel/data/models/order.dart';
import 'package:peppers_admin_panel/data/models/product.dart';
import 'package:peppers_admin_panel/data/models/promocode.dart';
import 'package:peppers_admin_panel/presentation/config/pikapika_exception.dart';

class Config {
  static String paymentMethodToString(
      {bool isIOS = false,
      required PaymentMethod paymentMethod,
      paybox.Card? savedCard}) {
    switch (paymentMethod) {
      case PaymentMethod.applePay:
        return "Apple Pay";
      case PaymentMethod.googlePay:
        return "Google Pay";
      case PaymentMethod.cash:
        return "Наличными";
      case PaymentMethod.nonCash:
        return "Kaspi";
      case PaymentMethod.bankCard:
        return "Банковской картой";
      case PaymentMethod.savedBankCard:
        return savedCard?.cardHash != null
            ? getCardLabel(savedCard!.cardHash!)
            : "Сохраненной картой";
    }
  }

  static PaymentMethod paymentMethodFromString(String paymentMethod) {
    switch (paymentMethod) {
      case "Apple Pay":
        return PaymentMethod.applePay;
      case "Google Pay":
        return PaymentMethod.googlePay;
      case "Наличными":
        return PaymentMethod.cash;
      case "Безналичными":
        return PaymentMethod.nonCash;
      case "Kaspi":
        return PaymentMethod.nonCash;
      case "Банковской картой":
        return PaymentMethod.bankCard;
      case "Банковской картой / Apple Pay":
        return PaymentMethod.bankCard;
      case "Сохраненной картой":
        return PaymentMethod.savedBankCard;
      default:
        throw PikapikaException("Illegal payment method");
    }
  }

  static String orderTypeToString(OrderType orderType) {
    switch (orderType) {
      case OrderType.delivery:
        return "Доставка";
      case OrderType.pickup:
        return "Самовывоз";
    }
  }

  static OrderType orderTypeFromString(String orderType) {
    switch (orderType) {
      case "Доставка":
        return OrderType.delivery;
      case "Самовывоз":
        return OrderType.pickup;
      default:
        throw PikapikaException("Illegal order type");
    }
  }

  static String orderStatusToString(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.unconfirmed:
        return "Неподтвержденный";
      case OrderStatus.waitCooking:
        return "В ожидании готовки";
      case OrderStatus.readyForCooking:
        return "Готов к приготовлению";
      case OrderStatus.cookingStarted:
        return "Приготовление";
      case OrderStatus.cookingCompleted:
        return "Приготовлен";
      case OrderStatus.waiting:
        return "В ожидании";
      case OrderStatus.onWay:
        return "В пути";
      case OrderStatus.delivered:
        return "Доставлен";
      case OrderStatus.closed:
        return "Закрыт";
      case OrderStatus.cancelled:
        return "Отменен";
    }
  }

  static OrderStatus orderStatusFromString(String orderStatus) {
    switch (orderStatus) {
      case "Неподтвержденный":
        return OrderStatus.unconfirmed;
      case "В ожидании готовки":
        return OrderStatus.waitCooking;
      case "Готов к приготовлению":
        return OrderStatus.readyForCooking;
      case "Приготовление":
        return OrderStatus.cookingStarted;
      case "Приготовлен":
        return OrderStatus.cookingCompleted;
      case "В ожидании":
        return OrderStatus.waiting;
      case "В пути":
        return OrderStatus.onWay;
      case "Доставлен":
        return OrderStatus.delivered;
      case "Закрыт":
        return OrderStatus.closed;
      case "Отменен":
        return OrderStatus.cancelled;
      default:
        throw PikapikaException("Illegal order status");
    }
  }

  static String getPaymentMethodIconPath(
      {required PaymentMethod paymentMethod, paybox.Card? savedCard}) {
    switch (paymentMethod) {
      case PaymentMethod.applePay:
        return "assets/icons/apple_pay.svg";
      case PaymentMethod.googlePay:
        return "assets/icons/google_pay.svg";
      case PaymentMethod.nonCash:
        return "assets/icons/non_cash.svg";
      case PaymentMethod.bankCard:
        return "assets/icons/credit.svg";
      case PaymentMethod.cash:
        return "assets/icons/cash.svg";
      case PaymentMethod.savedBankCard:
        return savedCard?.cardHash == null
            ? "assets/icons/credit.svg"
            : getIconUrl(savedCard!.cardHash!);
      default:
        return "assets/icons/credit.svg";
    }
  }

  static String getIconUrl(String cardHash) {
    switch (cardHash[0]) {
      case '4':
        return 'assets/icons/visa.svg';
      case '5':
        return 'assets/icons/mastercard.svg';
      default:
        return 'assets/icons/credit.svg';
    }
  }

  static String getCardLabel(String cardHash) {
    switch (cardHash[0]) {
      case '4':
        return 'Карта VISA ****${cardHash.substring(cardHash.length - 4)}';
      case '5':
        return 'Карта MasterCard ****${cardHash.substring(cardHash.length - 4)}';
      default:
        return 'Банковская карта ****${cardHash.substring(cardHash.length - 4)}';
    }
  }

  static String getTagTitle(ProductTags tag) {
    switch (tag) {
      case ProductTags.discount:
        return "Скидка";
      case ProductTags.hit:
        return "ХИТ";
      case ProductTags.latest:
        return "Новинка";
      default:
        return "";
    }
  }

  static String tagToMap(ProductTags tag) {
    switch (tag) {
      case ProductTags.hit:
        return "hit";
      case ProductTags.discount:
        return "discount";
      case ProductTags.latest:
        return "latest";
      case ProductTags.none:
        return "none";
    }
  }

  static ProductTags stringToTag(String tag) {
    switch (tag) {
      case "hit":
        return ProductTags.hit;
      case "discount":
        return ProductTags.discount;
      case "new":
        return ProductTags.latest;
      default:
        return ProductTags.none;
    }
  }

  static String getGiftGoalIconPath(String icon) {
    switch (icon) {
      case "cola":
        return 'assets/icons/cola_flat.svg';
      case "sushi":
        return 'assets/icons/sushi_flat.svg';
      case "pizza":
        return 'assets/icons/pizza_flat.svg';
      default:
        return 'assets/icons/gift_flat.svg';
    }
  }

  static String getGiftGoalTitle(String categoryID) {
    switch (categoryID) {
      case "gift1":
        return "Подарок №1";
      case "gift2":
        return "Подарок №2";
      case "gift3":
        return "Подарок №3";
      default:
        return "Подарок";
    }
  }

  static String promocodeTypeToString(PromocodeType type) {
    switch (type) {
      case PromocodeType.percent:
        return "Процентная скидка";
      case PromocodeType.fixed:
        return "Фиксированная скидка";
      case PromocodeType.flexible:
        return "Гибкая скидка";
    }
  }
}
