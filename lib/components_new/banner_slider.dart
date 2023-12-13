import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../components/custom_flushbar.dart';
import '../models/app_config_model.dart';
import '../utils/app_translations/app_translations.dart';

class BannerSlider extends StatefulWidget {
  final List<PromoBanner>? promoBanner;

  BannerSlider({
    @required this.promoBanner,
  });

  @override
  State<StatefulWidget> createState() {
    return _BannerSliderState();
  }
}

class _BannerSliderState extends State<BannerSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  // final List<String> imgList = [
  //   'https://halorider.oss-ap-southeast-3.aliyuncs.com/1682976680banner-test.png',
  //   'https://halorider.oss-ap-southeast-3.aliyuncs.com/1711431940banner-test.png',
  // ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.promoBanner!
        .map((item) => Container(
              margin: const EdgeInsets.all(5.0),
              child: GestureDetector(
                  onTap: () async {
                    print("okok ${item.promoActionUrl}");
                    if (item.promoActionUrl != null &&
                        item.promoActionUrl != '') {
                      if (await canLaunchUrl(Uri.parse(item.promoActionUrl!))) {
                        await launchUrl(Uri.parse(item.promoActionUrl!),
                            mode: LaunchMode.externalApplication);
                      } else {
                        showSimpleFlushBar(
                            AppTranslations.of(context).text('failed_to_load'),
                            context);
                      }
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl: item.promoImageUrl!,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )),
            ))
        .toList();
    return Column(children: [
      CarouselSlider(
        items: imageSliders,
        carouselController: _controller,
        options: CarouselOptions(
            height: 195,
            autoPlay: true,
            aspectRatio: 2.0,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.promoBanner!.map((i) {
          int index = widget.promoBanner!.indexOf(i);
          return GestureDetector(
            onTap: () => _controller.animateToPage(index),
            child: Container(
              width: 6.0,
              height: 6.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                    ? Colors.black.withOpacity(0.9)
                    : Colors.black.withOpacity(0.4),
              ),
            ),
          );
        }).toList(),
      ),
    ]);
  }
}
