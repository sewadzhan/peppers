//Model for product's features (weight, volume and etc)
class ProductFeature {
  String iconPath = '';
  String value;
  String dimension = '';

  ProductFeature(String type, this.value) {
    iconPath = getIconPath(type);
    dimension = getDimension(type);

    if (type == 'spicy') {
      value = 'Spicy';
    } else if (type == 'vegan') {
      value = 'Vegan';
    }
  }

  String getIconPath(String type) {
    switch (type) {
      case "count":
        return 'assets/icons/quantity.svg';
      case "diameter":
        return 'assets/icons/diameter.svg';
      case "volume":
        return 'assets/icons/volume.svg';
      case "persons":
        return 'assets/icons/persons.svg';
      case "weight":
        return 'assets/icons/weight.svg';
      case "vegan":
        return 'assets/icons/vegan.svg';
      case "spicy":
        return 'assets/icons/spicy.svg';
    }
    return "";
  }

  String getDimension(String type) {
    switch (type) {
      case "count":
        return 'шт';
      case "diameter":
        return 'см';
      case "volume":
        return 'л';
      case "persons":
        return 'персон';
      case "weight":
        return 'г';
    }
    return "";
  }
}
