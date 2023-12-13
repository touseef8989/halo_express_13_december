import 'package:flutter/material.dart';

import '../models/shop_model.dart';
import '../screens/main/shop_menu_page.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/styles.dart';
import 'horizontal_card.dart';

class HorizontalOrderList extends StatelessWidget {
  HorizontalOrderList({
    this.orders,
    this.controller,
  });

  // final List<int> orders;
  final List<ShopModel>? orders;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10.0, bottom: 6.0),
          child: Text(AppTranslations.of(context).text('order_again'),
              style: kTitleBoldTextStyle),
        ),
        Container(
          padding: EdgeInsets.only(top: 10.0),
          height: 90.0 + 60.0,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            controller: controller,
            itemCount: orders!.length,
            itemBuilder: (BuildContext context, int index) => HorizontalCard(
              cardHeight: 90.0,
              cardWidth: 90.0,
              image: orders![index].logoUrl,
              name: orders![index].shopName,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShopMenuPage(
                      shopUniqueCode: orders![index].uniqueCode!,
                      shopInfo: orders![index],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
