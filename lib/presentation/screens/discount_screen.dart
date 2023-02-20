import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/data/models/iiko_discount.dart';
import 'package:pikapika_admin_panel/data/models/promocode.dart';
import 'package:pikapika_admin_panel/logic/blocs/promocode/promocode_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/dialogs/discount_dialog.dart';
import 'package:pikapika_admin_panel/presentation/config/config.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  List<DataColumn> getColumns() {
    var columns = [
      "Код",
      "Тип скидки",
      "Величина",
      "Статус",
      "Лимит на использование",
      "Лимит по времени"
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

  List<DataRow> getRows(BuildContext context, List<Promocode> promocodes,
      List<IikoDiscount> iikoDiscounts) {
    return promocodes.map((e) {
      String hourlyLimit =
          e.startTimeLimit.isNotEmpty && e.finishTimeLimit.isNotEmpty
              ? "от ${e.startTimeLimit} до ${e.finishTimeLimit}"
              : "";

      return DataRow(
          onSelectChanged: (value) {
            showDiscountDialog(
                context, context.read<PromocodeBloc>(), e, iikoDiscounts);
          },
          cells: [
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(
                e.code,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(Config.promocodeTypeToString(e.type)),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(
                e.value.toString(),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    color: e.isActive
                        ? Constants.successColor
                        : Constants.errorColor,
                    borderRadius: const BorderRadius.all(Radius.circular(7))),
                child: Center(
                  child: Text(
                    e.isActive ? "Активен" : "Не активен",
                    textAlign: TextAlign.center,
                    style: Constants.textTheme.bodyMedium!.copyWith(
                      color: Constants.buttonTextColor,
                    ),
                  ),
                ),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.canBeUsedOnlyOnce
                  ? "Однократное использование"
                  : "Нет ограничений"),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(hourlyLimit),
            )),
          ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> rows = [];
    List<IikoDiscount> iikoDiscounts = [];

    return BlocConsumer<PromocodeBloc, PromocodeState>(
      listener: (context, state) {
        if (state is PromocodeSuccessSaved) {
          Navigator.pop(context);
          var successSnackBar = Constants.successSnackBar(
              context, "Данные успешно сохранены",
              duration: const Duration(milliseconds: 1600));
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        } else if (state is PromocodeSuccessDeleted) {
          Navigator.pop(context);
          var successSnackBar = Constants.successSnackBar(
              context, "Промокод успешно удален",
              duration: const Duration(milliseconds: 1600));
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        }
      },
      builder: (context1, state) {
        if (state is PromocodeInitialState || state is PromocodeLoadingState) {
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
        if (state is PromocodeLoadedState) {
          iikoDiscounts = state.iikoDiscounts;
          rows = getRows(context1, state.promocodes, state.iikoDiscounts);
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: Constants.defaultPadding * 0.5,
                      right: Constants.defaultPadding * 2,
                      bottom: Constants.defaultPadding * 0.5),
                  child: CustomElevatedButton(
                      text: "Добавить промокод",
                      width: 170,
                      height: 43,
                      fontSize: Constants.textTheme.bodyLarge!.fontSize,
                      function: () {
                        showDiscountDialog(
                            context1,
                            context1.read<PromocodeBloc>(),
                            null,
                            iikoDiscounts);
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: Constants.defaultPadding * 2,
                    right: Constants.defaultPadding * 2,
                    bottom: Constants.defaultPadding * 2,
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.defaultPadding,
                      vertical: Constants.defaultPadding * 1.5),
                  decoration: const BoxDecoration(
                      color: Constants.secondBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: Text(
                          "Промокоды",
                          style: Constants.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          "Все активные и неактивные промокоды и скидки ресторана",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: DataTable(
                                showCheckboxColumn: false,
                                horizontalMargin: 10,
                                dataRowHeight: 60,
                                columnSpacing: 35,
                                columns: getColumns(),
                                rows: rows)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //Show special dialog window for editing or adding a new one
  void showDiscountDialog(BuildContext context, PromocodeBloc promocodeBloc,
      Promocode? promocode, List<IikoDiscount> iikoDiscounts) {
    showDialog(
        context: context,
        builder: (context2) {
          return BlocProvider.value(
            value: promocodeBloc,
            child: DiscountDialog(
              promocode: promocode,
              iikoDiscounts: iikoDiscounts,
            ),
          );
        });
  }
}
