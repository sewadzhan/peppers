import 'package:pikapika_admin_panel/data/models/address.dart';
import 'package:pikapika_admin_panel/data/models/cashback_data.dart';
import 'package:pikapika_admin_panel/data/models/contacts.dart';
import 'package:pikapika_admin_panel/data/models/delivery_point.dart';
import 'package:pikapika_admin_panel/data/models/delivery_zone.dart';
import 'package:pikapika_admin_panel/data/models/gift_progress_bar.dart';
import 'package:pikapika_admin_panel/data/models/order.dart';
import 'package:pikapika_admin_panel/data/models/pikapika_user.dart';
import 'package:pikapika_admin_panel/data/models/promocode.dart';
import 'package:pikapika_admin_panel/data/models/promotion.dart';
import 'package:pikapika_admin_panel/data/providers/firestore_provider.dart';

class FirestoreRepository {
  final FirestoreProvider firestoreProvider;

  FirestoreRepository(this.firestoreProvider);

  //Get contacts
  Future<ContactsModel> getContactsData() async {
    var contactsSnapshot = await firestoreProvider.getContactsData();
    var data = contactsSnapshot.data();

    return ContactsModel.fromMap(data!);
  }

  //Get promotions
  Future<List<Promotion>> getPromotions() async {
    var promotionsDocs = await firestoreProvider.getPromotions();

    return promotionsDocs
        .map((snapshot) => Promotion.fromMap(snapshot.data(), snapshot.id))
        .toList();
  }

  //Write new user
  Future<void> writeNewUser(String phoneNumber, String name) async {
    await firestoreProvider.writeNewUser(phoneNumber, name);
  }

  //Edit current user
  Future<void> editUser(String phoneNumber, Map<String, dynamic> map) async {
    await firestoreProvider.editUser(phoneNumber, map);
  }

  //Remove current users personal information
  Future<void> deleteUser(String phoneNumber) async {
    await firestoreProvider.deleteUser(phoneNumber);
  }

  //Get data of current user in Firebase Firestore
  Future<PikapikaUser> retrieveUser(String phoneNumber) async {
    var data = await firestoreProvider.retrieveUser(phoneNumber);
    if (data == null) {
      throw Exception("No user in cloud Firestore with $phoneNumber phone");
    }
    return PikapikaUser.fromMap(data);
  }

  //Get all saved addresses of certain user
  Future<List<Address>> getAddressesOfUser(String phoneNumber) async {
    var addressesDocs = await firestoreProvider.getAddressesOfUser(phoneNumber);

    return addressesDocs
        .map((snapshot) => Address.fromMap(snapshot.data()))
        .toList();
  }

  //Add address to profile of certain phone number
  Future<void> addAddress(String phoneNumber, Address address) async {
    await firestoreProvider.addAddress(phoneNumber, address.toMap());
  }

  //Delete address from profile of certain phone number
  Future<void> removeAddress(String phoneNumber, Address address) async {
    await firestoreProvider.removeAddress(phoneNumber, address.toMap());
  }

  //Get gift goals
  Future<GiftProgressBarModel> getGiftProgressBarModel() async {
    var giftSnapshot = await firestoreProvider.getGiftGoals();
    var data = giftSnapshot.data();

    return GiftProgressBarModel.fromMap(data!);
  }

  //Retrieve all promocodes
  Future<List<Promocode>> getPromocodes() async {
    var promocodeDocs = await firestoreProvider.getPromocodes();

    print(promocodeDocs.map((snapshot) => snapshot.id).toList());

    return promocodeDocs
        .map((snapshot) => Promocode.fromMap(snapshot.data(), snapshot.id))
        .toList();
  }

  //Get delivery zones
  Future<List<DeliveryZone>> getDeliveryZones() async {
    var deliveryZonesDocs = await firestoreProvider.getDeliveryZones();

    return deliveryZonesDocs
        .map((snapshot) => DeliveryZone.fromMap(snapshot.data()))
        .toList();
  }

  //Add order
  Future<void> createOrder(Order order) async {
    await firestoreProvider.createOrder(order.toMap());
  }

  //Get order history of certain user
  Future<List<Order>> getOrderHistoryOfUser(String phoneNumber) async {
    var ordersDocs = await firestoreProvider.getOrderHistoryOfUser(phoneNumber);

    return ordersDocs
        .map((snapshot) => Order.fromMap(snapshot.data()))
        .toList();
  }

  //Get cashback system data (percent value, is enabled or not)
  Future<CashbackData> getCashbackData() async {
    var cashbackDoc = await firestoreProvider.getCashbackData();
    return CashbackData.fromMap(cashbackDoc.data()!);
  }

  //Update cashback system data (percent value, is enabled or not)
  Future<void> updateCashbackData(bool isEnabled, int percent) async {
    await firestoreProvider
        .updateCashbackData({'isEnabled': isEnabled, 'percent': percent});
  }

  //Edit user cashback
  Future<void> editUserCashback(String phoneNumber, int newCashback) async {
    await firestoreProvider.editUserCashback(phoneNumber, newCashback);
  }

  //Get user cashback
  Future<int> getUserCashback(String phoneNumber) async {
    var userDoc = await firestoreProvider.retrieveUser(phoneNumber);
    return userDoc!['cashback'] ?? 0;
  }

  //Sending email using Firebase extension
  Future<void> sendEmail(
      String sendEmailTo, String subject, String html) async {
    await firestoreProvider.sendEmail(sendEmailTo, subject, html);
  }

  //Update contacts data (phone, email, socials and etc)
  Future<void> updateContactsData(ContactsModel contactsModel) async {
    await firestoreProvider.updateContactsData(contactsModel.toMap());
  }

  //Update the certain data of promocode
  Future<void> updatePromocodeData(Promocode promocode) async {
    await firestoreProvider.updatePromocodeData(
        promocode.id, promocode.toMap());
  }

  //Add new promocode
  Future<String> addPromocode(Promocode promocode) async {
    return await firestoreProvider.addPromocode(promocode.toMap());
  }

  //Delete promocode
  Future<void> deletePromocode(String promocodeID) async {
    await firestoreProvider.deletePromocode(promocodeID);
  }

  //Update the certain data of promotion
  Future<void> updatePromotionData(Promotion promotion) async {
    await firestoreProvider.updatePromotionData(
        promotion.id, promotion.toMap());
  }

  //Add new promotion
  Future<String> addPromotion(Promotion promotion) async {
    return await firestoreProvider.addPromotion(promotion.toMap());
  }

  //Delete promotion
  Future<void> deletePromotionData(String promotionID) async {
    await firestoreProvider.deletePromotionData(promotionID);
  }

  //Update the pickup point
  Future<void> updatePickupPointData(DeliveryPoint point) async {
    await firestoreProvider.updatePickupPointData(point.toMap(), point.id);
  }

  //Delete the certain pickup point
  Future<void> deletePickupPointData(String id) async {
    await firestoreProvider.deletePickupPointData(id);
  }
}
