import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:peppers_admin_panel/data/models/order.dart';
import 'package:peppers_admin_panel/logic/blocs/order/order_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/dialogs/order_dialog.dart';
import 'package:peppers_admin_panel/presentation/config/config.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  List<DataColumn> getColumns() {
    var columns = [
      "ID заказа",
      "Дата",
      "Номер телефона",
      "Платеж",
      "Итого",
    ];

    return columns.map((String column) {
      return DataColumn(
        label: Text(
          column,
          style: Constants.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context1, state) {
        if (state is OrderInitialState || state is OrderLoadingState) {
          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: Constants.primaryColor,
              ),
            ),
          );
        }
        if (state is OrderLoadedState) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.all(
                    Constants.defaultPadding * 1.5,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding,
                      vertical: Constants.defaultPadding * 1.5),
                  decoration: const BoxDecoration(
                      color: Constants.secondBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: Text(
                          "Заказы",
                          style: Constants.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          "Все заказы с мобильного приложения ресторана",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: PaginatedDataTable(
                          rowsPerPage: 15,
                          source: OrderData(state.orders, context),
                          showCheckboxColumn: false,
                          horizontalMargin: 10,
                          dataRowHeight: 70,
                          columnSpacing: 35,
                          columns: getColumns(),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class OrderData extends DataTableSource {
  final List<Order> orders;
  final BuildContext context;

  OrderData(this.orders, this.context);

  //Show special dialog window for editing or adding a new one
  void showOrderDialog(BuildContext context, Order order) {
    showDialog(
        context: context,
        builder: (context2) {
          return OrderDialog(
            order: order,
          );
        });
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(
        onSelectChanged: (value) {
          showOrderDialog(context, orders[index]);
        },
        cells: [
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              "#${orders[index].id}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              DateFormat('dd.MM.yyyy, kk:mm').format(orders[index].dateTime),
            ),
          )),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              orders[index].phoneNumber,
            ),
          )),
          DataCell(Container(
              width: 350,
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(orders[index].fullAddress),
                  Text(
                    Config.paymentMethodToString(
                        paymentMethod: orders[index].paymentMethod),
                    style: const TextStyle(color: Constants.middleGrayColor),
                  )
                ],
              ))),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              "${orders[index].total}₸",
            ),
          )),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.length;

  @override
  int get selectedRowCount => 0;
}
