import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/address_model.dart';
import '../utils/app_translations/app_translations.dart';
import '../utils/constants/fonts.dart';
import '../utils/constants/styles.dart';
import 'address_icon.dart';

class AddressDetail extends StatelessWidget {
  AddressDetail({
    this.addresses,
    this.selectedId,
    this.showContact = false,
  });

  final List<AddressModel>? addresses;
  final String? selectedId;
  final bool? showContact;

  renderAddresses(BuildContext context) {
    List<Widget> addressesView = [];

    if (addresses != null) {
      for (int i = 0; i < addresses!.length; i++) {
        AddressModel? address = addresses![i];

        Widget view = Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(address.receiverName != null && address.receiverName != '') ? address.receiverName : ''} ${showContact! ? " - ${address.receiverPhone}" : ""}',
                overflow: TextOverflow.ellipsis,
                style: kAddressPlaceholderTextStyle.copyWith(fontSize: 14),
              ),
              Text(
                address.fullAddress!,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
                style: const TextStyle(
                  fontFamily: poppinsSemiBold,
                  fontSize: 14,
                ),
              ),
              if (selectedId != null && selectedId == address.addressId)
                Row(
                  children: [
                    Image.asset(
                      "images/ic_green_tick.png",
                      width: 25.0,
                      height: 25.0,
                    ),
                    const SizedBox(
                      width: 3.0,
                    ),
                    Flexible(
                        child: Text(
                      AppTranslations.of(context)
                          .text('rider_will_collect_payment_at_this_address'),
                      style: const TextStyle(
                        fontFamily: poppinsMedium,
                        color: Colors.green,
                      ),
                    ))
                  ],
                )
            ],
          ),
        );

        if (i == 1) {
          addressesView.add(const Divider());
        }

        addressesView.add(view);
      }

      return addressesView;
    }

    return addressesView;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              AddressIcon(),
              Transform.rotate(
                angle: 180 * math.pi / 180,
                child: AddressIcon(),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: renderAddresses(context),
            ),
          )
        ],
      ),
    );
  }
}
