import 'food_variant_model.dart';

class FoodModel {
  String? foodId;
  String? name;
  String? price;
  String? description;
  bool? status;
  String? imageUrl;
  List<FoodVariantModel>? variants;
  bool? priceDiscountStatus;
  String? priceDiscounted;
  bool? imgPromoTag;
  String? imgPromoTagText;
  String? descriptionAutoTrim;

  FoodModel(
      {this.foodId,
      this.name,
      this.price,
      this.description,
      this.status,
      this.imageUrl,
      this.priceDiscounted,
      this.priceDiscountStatus,
      this.variants,
      this.imgPromoTag,
      this.descriptionAutoTrim,
      this.imgPromoTagText});
}
