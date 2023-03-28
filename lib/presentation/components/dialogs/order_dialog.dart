import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:peppers_admin_panel/data/models/order.dart';
import 'package:peppers_admin_panel/presentation/config/config.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class OrderDialog extends StatelessWidget {
  final Order order;

  const OrderDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(Constants.defaultPadding * 0.5),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Container(
          width: 600,
          padding: EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
              vertical: Constants.defaultPadding * 1.75),
          decoration: const BoxDecoration(
              color: Constants.secondBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                child: Text(
                  "Заказ #${order.id}",
                  style: Constants.textTheme.displayMedium,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                child: Text(
                  DateFormat('dd.MM.yyyy, kk:mm').format(order.dateTime),
                  style: Constants.textTheme.headlineMedium!
                      .copyWith(color: Constants.middleGrayColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: Constants.defaultPadding),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: order.cartItems.length,
                      itemBuilder: (context, index) => Column(
                            children: [
                              Row(
                                children: [
                                  // Container(
                                  //   width: 67,
                                  //   height: 40,
                                  //   decoration: const BoxDecoration(
                                  //       borderRadius:
                                  //           BorderRadius.all(Radius.circular(4)),
                                  //       image: DecorationImage(
                                  //           image: NetworkImage(
                                  //               'https://pikapika.kz/wp-content/uploads/2021/08/%D0%A7%D1%83%D0%BA%D0%B0-%D1%80%D0%BE%D0%BB%D0%BB.jpg'),
                                  //           fit: BoxFit.cover)),
                                  // ),
                                  // const SizedBox(
                                  //     width: Constants.defaultPadding * 0.5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          order.cartItems[index].product.title,
                                          style: Constants.textTheme.titleLarge,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${order.cartItems[index].count}x",
                                            style: Constants
                                                .textTheme.bodyMedium!
                                                .copyWith(
                                                    fontSize: 10,
                                                    color: Constants
                                                        .middleGrayColor),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                              "${order.cartItems[index].product.price}₸",
                                              style: Constants
                                                  .textTheme.titleLarge)
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Constants.lightGrayColor,
                                ),
                              ),
                            ],
                          )),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Скидка по промокоду:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Text(
                      "${order.discount}₸",
                      style: Constants.textTheme.headlineSmall,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Доставка:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Text(
                      "${order.deliveryCost}₸",
                      style: Constants.textTheme.headlineSmall,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Итого:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Text(
                      "${order.total}₸",
                      style: Constants.textTheme.headlineSmall,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Способ получения:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Text(
                      Config.orderTypeToString(order.orderType),
                      style: Constants.textTheme.headlineMedium,
                    )
                  ],
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                  child: Text(order.fullAddress,
                      style: Constants.textTheme.bodyLarge)),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Способ оплаты:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Text(
                      Config.paymentMethodToString(
                          paymentMethod: order.paymentMethod),
                      style: Constants.textTheme.headlineMedium,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Накопительные баллы:",
                      style: Constants.textTheme.headlineMedium,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            Text(
                                order.cashbackUsed > 0
                                    ? "+" + order.cashbackUsed.toString()
                                    : order.cashbackUsed.toString(),
                                style: Constants.textTheme.bodyLarge!.copyWith(
                                    fontSize: 18,
                                    color: Constants.primaryColor)),
                            const SizedBox(width: 5),
                            SvgPicture.asset(
                              "assets/icons/pikapika.svg",
                              width: 20,
                              color: Constants.primaryColor,
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
