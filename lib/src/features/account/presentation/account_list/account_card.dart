import 'package:avenique/src/features/account/presentation/screen/edit_account_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 150 / 85,
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .push(EditAccountScreen.route(context, initialAccount: account)),
        child: Card(
            child: Container(
          padding: EdgeInsets.fromLTRB(16, 4, 12, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.wallet),
              Text(account.name, overflow: TextOverflow.ellipsis),
              Text(account.balance, overflow: TextOverflow.ellipsis),
            ],
          ),
        )),
      ),
    );
  }
}

    // SizedBox(
    //   width: 150,
    //   child: Card(
    //       color: Colors.blue,
    //       shape:
    //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
    //         child: Column(
    //           children: [
    //             Text(account.name),
    //             Text(account.balance),
    //           ],
    //         ),
    //       )),
    // );