import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peppers_admin_panel/logic/blocs/order_history/order_history_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/order_history_list_tile.dart.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    context.read<OrderHistoryBloc>().add(LoadOrderHistory(phoneNumber));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.secondBackgroundColor,
        foregroundColor: Constants.darkGrayColor,
        title: Text(
          "История заказов $phoneNumber",
          style: Constants.textTheme.displaySmall,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<OrderHistoryBloc, OrderHistoryState>(
          listener: (context, state) {
            if (state is OrderHistoryErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                  Constants.errorSnackBar(context, state.message,
                      duration: const Duration(milliseconds: 1600)));
            }
          },
          builder: (context, state) {
            if (state is OrderHistoryLoaded) {
              if (state.orders.isEmpty) {
                return SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 225,
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 1.5),
                          child: Image.asset(
                            'assets/decorations/cart_empty.png',
                          )),
                      Text(
                        "У данного аккаунта отсутствуют заказы",
                        textAlign: TextAlign.center,
                        style: Constants.textTheme.bodyLarge!.copyWith(
                          color: Constants.middleGrayColor,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) =>
                      OrderHistoryListTile(order: state.orders[index]));
            }
            return Padding(
              padding: EdgeInsets.all(Constants.defaultPadding),
              child: const Center(
                child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Constants.primaryColor,
                      strokeWidth: 2.5,
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
