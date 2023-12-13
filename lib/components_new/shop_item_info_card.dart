import 'package:flutter/material.dart';

import '../models/food_model.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/styles.dart';

class ShopItemInfoCard extends StatelessWidget {
  ShopItemInfoCard({this.food});

  // final List<int> cravings;
  final FoodModel? food;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 10.0, // has the effect of softening the shadow

            offset: const Offset(
              0, // horizontal, move right 10
              5.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Material(
        color: Colors.grey[100],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      food!.name!,
                      style: kTitleSemiBoldTextStyle,
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${AppTranslations.of(context).text('currency_my')} ${food!.price}',
                        style: kLabelTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                food!.description!,
                style: kLabelTextStyle.copyWith(color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}
