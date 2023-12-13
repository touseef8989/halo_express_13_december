import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../components/custom_flushbar.dart';
import '../models/app_config_model.dart';
import '../models/shop_model.dart';
import '../models/user_model.dart';
import '../networkings/food_networking.dart';
import '../screens/boarding/login_page.dart';
import '../screens/main/shop_menu_page.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/custom_colors.dart';
import '../utils/constants/fonts.dart';
import '../utils/constants/styles.dart';
import '../utils/services/pop_with_result_service.dart';
import 'shop_tag.dart';

class ShopCategoryRenderModel {
  bool isHighlight;
  String categoryTitle;

  ShopCategoryRenderModel(this.isHighlight, this.categoryTitle);
}

// ignore: must_be_immutable
class ShopCard extends StatelessWidget {
  ShopCard({
    this.shop,
    this.shopType,
    this.callbackMethod,
  });

  // final List<int> cravings;
  final ShopModel? shop;
  String? shopType;
  final Function? callbackMethod;

  renderTextRowCategory(String key) {
    List<ShopCategoryRenderModel> list = [];
    if (shop!.category!.length > 3) {
      shop!.category!.sublist(0, 3).forEach((element) {
        list.add(ShopCategoryRenderModel(
            ShopModel.isHighLightCategory(element), element));
      });
    } else {
      shop!.category!.forEach((element) {
        list.add(ShopCategoryRenderModel(
            ShopModel.isHighLightCategory(element), element));
      });
    }
    list.sort(
        (a, b) => b.isHighlight.toString().compareTo(a.isHighlight.toString()));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            key,
            style: kSmallLabelTextStyle.copyWith(color: Colors.grey),
          ),
        ),
        Expanded(
            child: Wrap(
          alignment: WrapAlignment.end,
          children: list.map((e) {
            bool isLast = list.indexOf(e) == list.length - 1;
            return Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(
                  e.categoryTitle,
                  style: e.isHighlight
                      ? kSmallTitleBoldTextStyle.copyWith(color: kColorRed)
                      : kSmallLabelTextStyle.copyWith(color: Colors.grey),
                  textAlign: TextAlign.end,
                ),
                if (!isLast)
                  Text(
                    " ,",
                    style: kSmallLabelTextStyle.copyWith(color: Colors.grey),
                  )
              ],
            );
          }).toList(),
        )),
      ],
    );
  }

  Widget renderTextRow(String key, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            key,
            style: kSmallLabelTextStyle.copyWith(color: Colors.grey),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: kSmallLabelTextStyle.copyWith(color: Colors.grey),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  renderRatingBar(String key, String value) {
    print(value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "",
            style: kSmallLabelTextStyle.copyWith(color: Colors.grey),
          ),
        ),
        Expanded(
            child: Wrap(alignment: WrapAlignment.end, children: [
          RatingBar.builder(
            itemSize: 16,
            ignoreGestures: true,
            initialRating: double.parse(value),
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
          Text(
            '(${shop!.totalOrder})',
            style: const TextStyle(color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ])),
      ],
    );
  }

  void toggleFavShop(BuildContext context) async {
    if (User().getAuthToken() == null) {
      Navigator.pushNamed(context, LoginPage.id);
      return;
    }

    Map<String, dynamic> params = {
      "data": {
        "shopUniqueCode": shop!.uniqueCode,
      }
    };

    try {
      if (shop!.shopUserFavourite!) {
        await FoodNetworking().removeFavShop(params);
      } else {
        await FoodNetworking().addFavShop(params);
      }
      callbackMethod!();
    } catch (e) {
      showSimpleFlushBar("$e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("5656 ${shopType}");
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShopMenuPage(
                shopType: shopType!,
                shopUniqueCode: shop!.uniqueCode!,
                shopInfo: shop!,
              ),
            ),
          ).then((value) {
            if (value is PopWithResults) {
              PopWithResults popResult = value;
              if (popResult.toPage == 'foodMain') {
                // TODO: pop current order banner and refresh
                // getNearbyShopList();
                if (callbackMethod != null) callbackMethod!();
              } else {
                // pop to previous page
                Navigator.of(context).pop(value);
              }
            } else if (value is ShopMenuPageReturnResult) {
              if (callbackMethod != null &&
                  value.isFav != shop!.shopUserFavourite) {
                callbackMethod!();
              }
            }
          });
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          // color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    // fit: BoxFit.fitWidth,
                    imageUrl: shop!.logoUrl!,
                    placeholder: (context, url) => Image.asset(
                      "images/haloje_placeholder.png",
                      width: 100,
                      height: 100,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 100,
                    height: 100,
                  ),
                  if (shop!.featuresStatus!)
                    Positioned(
                      top: 8.0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 8.0),
                        color: kColorLightRed,
                        child: Text(
                          shop!.featuresDisplay!,
                          style: const TextStyle(
                              fontFamily: poppinsMedium,
                              fontSize: 11,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  (shop!.shopStatus == 'open')
                      ? Container()
                      : Positioned.fill(
                          child: Container(
                            color: Colors.white.withOpacity(0.6),
                          ),
                        )
                ],
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            shop!.shopName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontFamily: poppinsMedium, fontSize: 15),
                          ),
                        ),
                        Visibility(
                          visible: shopType == 'donation' ? false : true,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6.0, right: 6.0),
                              child: Icon(
                                  shop!.shopUserFavourite!
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                  size: 20.0,
                                  color: Colors.red),
                            ),
                            onTap: () {
                              toggleFavShop(context);
                            },
                          ),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                    Visibility(
                      visible: shopType == 'donation' ? true : false,
                      child: renderTextRow(
                        AppTranslations.of(context).text('location'),
                        (shop!.city!),
                      ),
                    ),
                    Visibility(
                      visible: shopType == 'food' ? true : false,
                      child: renderTextRow(
                        AppTranslations.of(context).text('distance'),
                        '${(shop!.distance)!.toStringAsFixed(1)} km',
                      ),
                    ),

                    Visibility(
                      visible: shopType == 'food' || shopType == 'marketplace'
                          ? false
                          : true,
                      child: renderTextRow(
                        AppTranslations.of(context).text('delivery_fee'),
                        'RM ${(shop!.shopDeliveryFee).toString()}',
                      ),
                    ),
                    // renderTextRowCategory(
                    //   AppTranslations.of(context)!.text('category'),
                    // ),
                    if (shop!.totalOrder != "0")
                      renderRatingBar(
                          AppTranslations.of(context).text('rating'),
                          shop!.rating!),
                    if (shop!.shopStatus != 'open')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: kColorRed,
                            padding: const EdgeInsets.symmetric(
                              vertical: 3.0,
                              horizontal: 6.0,
                            ),
                            margin: const EdgeInsets.only(right: 5),
                            child: Text(
                              shop!.shopClosePreOrder!
                                  ? shop!.closeShopText!
                                  : AppTranslations.of(context).text('closed'),
                              style: kSmallLabelTextStyle.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Text(
                          //   shop.closeShopText,
                          //   style: kSmallLabelTextStyle.copyWith(
                          //     color: Colors.black,
                          //     fontSize: 12,
                          //   ),
                          // ),
                        ],
                      ),
                    const SizedBox(height: 6.0),
                    Visibility(
                      visible: shopType == 'donation' ? false : true,
                      child: Wrap(
                        children: [
                          ...shop!.shopTag!
                              .map(
                                (e) => Container(
                                  margin: const EdgeInsets.only(
                                      right: 8, top: 3.0, bottom: 3.0),
                                  child: ShopTag(
                                    tag: e,
                                    isHighlight: AppConfig
                                        .consumerConfig!.highlightCategory!
                                        .contains(e),
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
