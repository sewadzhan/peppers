import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:peppers_admin_panel/data/models/order.dart';
import 'package:peppers_admin_panel/presentation/components/dialogs/order_dialog.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class OrderHistoryListTile extends StatelessWidget {
  const OrderHistoryListTile({
    Key? key,
    required this.order,
  }) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context2) {
              return OrderDialog(
                order: order,
              );
            });
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 15, horizontal: Constants.defaultPadding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Заказ №${order.id}",
                          style: Constants.textTheme.headlineMedium),
                      Text(
                        DateFormat('dd.MM.yyyy, kk:mm').format(order.dateTime),
                        style: Constants.textTheme.bodyLarge!.copyWith(
                          color: Constants.middleGrayColor,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Text(
                              order.cashbackUsed > 0
                                  ? "+${order.cashbackUsed}"
                                  : order.cashbackUsed.toString(),
                              style: Constants.textTheme.bodyLarge!.copyWith(
                                  fontSize: 18, color: Constants.primaryColor)),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            "assets/icons/pikapika.svg",
                            width: 20,
                            color: Constants.primaryColor,
                          )
                        ],
                      )),
                ]),
          ),
          const Divider(
            height: 1,
            thickness: 1,
            color: Constants.lightGrayColor,
          ),
        ],
      ),
    );
  }
}
