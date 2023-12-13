import 'package:flutter/material.dart';

class Wallet extends StatelessWidget {
  Wallet({
    this.balance,
  });

  final String? balance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: const Icon(
              Icons.wallet_membership,
              color: Colors.yellow,
            ),
          ),
          Text(
            balance!,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
