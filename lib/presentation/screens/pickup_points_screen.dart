import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peppers_admin_panel/data/models/delivery_point.dart';
import 'package:peppers_admin_panel/data/models/iiko_organization.dart';
import 'package:peppers_admin_panel/logic/blocs/contact/contact_bloc.dart';
import 'package:peppers_admin_panel/logic/blocs/pickup_points/pickup_point_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/components/dialogs/pickup_point_dialog.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class PickupPointsScreen extends StatelessWidget {
  const PickupPointsScreen({super.key});

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((String column) {
      return DataColumn(
        label: Text(
          column,
          style: Constants.textTheme.headlineSmall,
        ),
      );
    }).toList();
  }

  List<DataRow> getRows(
      BuildContext context,
      List<DeliveryPoint> deliveryPoints,
      List<IikoOrganization> iikoOrganizations) {
    return deliveryPoints.map((e) {
      return DataRow(
          onSelectChanged: (value) {
            showPickupPointDialog(
                context, context.read<PickupPointBloc>(), e, iikoOrganizations);
          },
          cells: [
            DataCell(Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.address),
            )),
            DataCell(Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(iikoOrganizations
                  .where((element) => element.id == e.organizationID)
                  .first
                  .name),
            )),
            DataCell(Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: CustomElevatedButton(
                  text: "Посмотреть",
                  width: 105,
                  height: 35,
                  fontSize: Constants.textTheme.bodyMedium!.fontSize,
                  backgroundColor: Constants.secondPrimaryColor,
                  function: () {
                    Navigator.of(context).pushNamed('/geopoint', arguments: e);
                  }),
            )),
          ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      "Адрес точки",
      "Организация в IIKO",
      "Точка на карте",
    ];

    List<DataRow> rows = [];
    List<IikoOrganization> organizations = [];

    return BlocConsumer<PickupPointBloc, PickupPointState>(
      listener: (context, state) {
        if (state is PickupPointErrorState) {
          var errorSnackBar = Constants.errorSnackBar(context, state.message,
              duration: const Duration(milliseconds: 1000));
          ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
        } else if (state is PickupPointSuccessSaved) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, "Данные успешно сохранены",
              duration: const Duration(milliseconds: 1600)));

          Navigator.of(context).pop();
        } else if (state is PickupPointSuccessDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(Constants.successSnackBar(
              context, "Точка успешно удалена",
              duration: const Duration(milliseconds: 1600)));

          Navigator.of(context).pop();
        }
      },
      builder: (context, pickupPointState) {
        return BlocBuilder<ContactBloc, ContactState>(
          builder: (context1, contactState) {
            if (pickupPointState is PickupPointLoadingState ||
                pickupPointState is PickupPointInitialState ||
                contactState is ContactInitial ||
                contactState is ContactLoading) {
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
            if (contactState is ContactLoaded &&
                pickupPointState is PickupPointLoadedState) {
              organizations = pickupPointState.iikoOrganizations;
              rows = getRows(context1, contactState.contactsModel.pickupPoints,
                  organizations);
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: Constants.defaultPadding * 0.5,
                        right: Constants.defaultPadding * 1.5,
                        bottom: Constants.defaultPadding * 0.5),
                    child: CustomElevatedButton(
                        text: "Добавить точку",
                        width: 150,
                        height: 43,
                        fontSize: Constants.textTheme.bodyLarge!.fontSize,
                        function: () {
                          showPickupPointDialog(
                              context,
                              context.read<PickupPointBloc>(),
                              null,
                              organizations);
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      left: Constants.defaultPadding * 1.5,
                      right: Constants.defaultPadding * 1.5,
                      bottom: Constants.defaultPadding * 1.5,
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
                            "Точки самовывоза",
                            style: Constants.textTheme.headlineMedium,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: Constants.defaultPadding * 1.5),
                          child: Text(
                            "В данной таблице указаны все точки самовывоза ресторана",
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
                                  dataRowHeight: 90,
                                  columnSpacing: 35,
                                  columns: getColumns(columns),
                                  rows: rows)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Show special dialog window for editing or adding a new one
  void showPickupPointDialog(
      BuildContext context,
      PickupPointBloc pickupPointBloc,
      DeliveryPoint? pickupPoint,
      List<IikoOrganization> iikoOrganizations) {
    showDialog(
        context: context,
        builder: (context2) {
          return BlocProvider.value(
            value: pickupPointBloc,
            child: PickupPointDialog(
              pickupPoint: pickupPoint,
              iikoOrganizations: iikoOrganizations,
            ),
          );
        });
  }
}
