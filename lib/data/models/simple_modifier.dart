//Class for simple modifier of product in Iiko Menu
class SimpleModifier {
  final String name;
  final int price;
  final String iikoID;
  final int minAmount;
  final int maxAmount;
  final int defaultAmount;

  SimpleModifier(
      {required this.name,
      required this.price,
      required this.iikoID,
      required this.minAmount,
      required this.maxAmount,
      required this.defaultAmount});
}
