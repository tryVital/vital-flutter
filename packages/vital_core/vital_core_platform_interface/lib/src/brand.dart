enum Brand { omron, accuChek, contour, beurer, libre }

Brand brandFromString(String name) {
  switch (name) {
    case "omron":
      return Brand.omron;
    case "accuChek":
      return Brand.accuChek;
    case "contour":
      return Brand.contour;
    case "beurer":
      return Brand.beurer;
    case "libre":
      return Brand.libre;
    default:
      throw Exception("Unknown brand: $name");
  }
}
