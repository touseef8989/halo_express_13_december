import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/shop_model.dart';
import 'shop_info_card.dart';

class HorizontalMerchantCard extends StatelessWidget {
  HorizontalMerchantCard({
    this.headerImgUrl,
    this.logoUrl,
    this.shopInfo,
    this.cardHeight,
    this.onClick,
  });

  final String? headerImgUrl;
  final String? logoUrl;
  final ShopModel? shopInfo;
  final double? cardHeight;
  final Function? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick!(),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        padding: const EdgeInsets.only(right: 16),
        height: cardHeight,
        child: Stack(
          children: [
            (headerImgUrl != '')
                ? CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    imageUrl: headerImgUrl!,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: 230,
                    imageUrl: logoUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              bottom: 0,
              child: ShopInfoCard(
                shop: shopInfo!,
                isShopInfo: true,
                isHomePage: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
