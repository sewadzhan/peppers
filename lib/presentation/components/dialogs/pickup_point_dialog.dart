import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:peppers_admin_panel/data/models/delivery_point.dart';
import 'package:peppers_admin_panel/data/models/iiko_organization.dart';
import 'package:peppers_admin_panel/logic/blocs/pickup_points/pickup_point_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class PickupPointDialog extends StatefulWidget {
  const PickupPointDialog(
      {super.key, required this.pickupPoint, required this.iikoOrganizations});

  final DeliveryPoint? pickupPoint;
  final List<IikoOrganization> iikoOrganizations;

  @override
  State<PickupPointDialog> createState() => _PickupPointDialogState();
}

class _PickupPointDialogState extends State<PickupPointDialog> {
  late TextEditingController geopointController;
  late TextEditingController addressController;
  late String organizationIdController;
  late IikoOrganization? initialIikoOrganization;

  @override
  void initState() {
    initialIikoOrganization = null;
    addressController = widget.pickupPoint == null
        ? TextEditingController()
        : TextEditingController(text: widget.pickupPoint!.address);
    geopointController = widget.pickupPoint == null
        ? TextEditingController()
        : TextEditingController(
            text:
                "${widget.pickupPoint!.latLng.latitude},${widget.pickupPoint!.latLng.longitude}");
    organizationIdController =
        widget.pickupPoint == null ? "" : widget.pickupPoint!.organizationID;

    if (widget.pickupPoint != null) {
      var tmp = widget.iikoOrganizations
          .where((element) => element.id == widget.pickupPoint!.organizationID);
      if (tmp.isNotEmpty) {
        initialIikoOrganization = tmp.first;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(initialIikoOrganization);
    return ScaffoldMessenger(
      child: Builder(builder: (dialogContext) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Dialog(
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
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 0.5),
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.pickupPoint == null
                                    ? "Добавление новой точки самовывоза"
                                    : "Редактирование точки самовывоза",
                                style: Constants.textTheme.displaySmall,
                              ),
                              widget.pickupPoint != null
                                  ? BlocBuilder<PickupPointBloc,
                                      PickupPointState>(
                                      builder: (context, state) {
                                        if (state is PickupPointDeletingState) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                right:
                                                    Constants.defaultPadding *
                                                        0.5),
                                            width: 15,
                                            height: 15,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 1.5,
                                              color:
                                                  Constants.secondPrimaryColor,
                                            ),
                                          );
                                        }
                                        return TextButton(
                                          style: TextButton.styleFrom(
                                            shape: const CircleBorder(),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/trash.svg',
                                            color: Constants.secondPrimaryColor,
                                            width: 15,
                                          ),
                                          onPressed: () {
                                            context.read<PickupPointBloc>().add(
                                                DeletePickupPoint(
                                                    id: widget
                                                        .pickupPoint!.id));
                                          },
                                        );
                                      },
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          widget.pickupPoint == null
                              ? "Введите все необходимые данные для добавления точки самовывоза"
                              : "Для редактирования внесите изменения и нажмите кнопку \"Сохранить\"",
                          style: Constants.textTheme.bodyLarge!
                              .copyWith(color: Constants.middleGrayColor),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding,
                        ),
                        child: CustomTextInputField(
                            titleText: "Адрес точки",
                            hintText: "Например: Лебедева 7",
                            keyboardType: TextInputType.text,
                            controller: addressController),
                      ),
                      Text(
                        "IIKO организация точки",
                        style: Constants.textTheme.headlineSmall,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: Constants.defaultPadding * 0.5,
                          bottom: Constants.defaultPadding,
                        ),
                        child: DropdownButton(
                          value: initialIikoOrganization,
                          focusColor: Constants.secondPrimaryColor,
                          hint: Text("IIKO организация точки",
                              style: Constants.textTheme.bodyLarge!.copyWith(
                                  color: Constants.textFieldGrayColor)),
                          items: widget.iikoOrganizations
                              .map((organization) => DropdownMenuItem(
                                    value: organization,
                                    child: Text(
                                      organization.name,
                                      style: Constants.textTheme.bodyLarge,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (organization) {
                            if (organization != null) {
                              setState(() {
                                initialIikoOrganization = organization;
                                organizationIdController = organization.id;
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: Constants.defaultPadding * 1.5,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomTextInputField(
                                  onlyRead: true,
                                  titleText: "Координаты точки",
                                  hintText:
                                      "Выберите на карте точку самовывоза",
                                  controller: geopointController),
                            ),
                            SizedBox(
                              width: Constants.defaultPadding,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CustomElevatedButton(
                                  width: 140,
                                  text: "Выбрать на карте",
                                  fontSize:
                                      Constants.textTheme.bodyMedium!.fontSize,
                                  backgroundColor: Constants.secondPrimaryColor,
                                  function: () async {
                                    var chosenGeopoint =
                                        await Navigator.of(context)
                                            .pushNamed('/geopoint');

                                    if (chosenGeopoint != null) {
                                      setState(() {
                                        geopointController = TextEditingController(
                                            text:
                                                "${(chosenGeopoint as LatLng).latitude},${chosenGeopoint.longitude}");
                                      });
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocConsumer<PickupPointBloc, PickupPointState>(
                            listener: (context, state) {
                              if (state is PickupPointErrorState) {
                                var errorSnackBar = Constants.errorSnackBar(
                                    dialogContext, state.message,
                                    duration:
                                        const Duration(milliseconds: 1000));
                                ScaffoldMessenger.of(dialogContext)
                                    .showSnackBar(errorSnackBar);
                              }
                            },
                            builder: (context3, state) {
                              return CustomElevatedButton(
                                  text: "Сохранить",
                                  width: 130,
                                  isLoading: state is PickupPointSavingState,
                                  height: 43,
                                  fontSize:
                                      Constants.textTheme.bodyLarge!.fontSize,
                                  function: () {
                                    //Add the new Promocode
                                    if (widget.pickupPoint == null) {
                                      context.read<PickupPointBloc>().add(
                                          AddPickupPoint(
                                              address: addressController.text,
                                              organizationID:
                                                  organizationIdController,
                                              latlng: geopointController.text));
                                    }
                                    //Edit the existed Promocode
                                    else {
                                      context.read<PickupPointBloc>().add(
                                          UpdatePickupPointData(
                                              id: widget.pickupPoint!.id,
                                              address: addressController.text,
                                              organizationID:
                                                  organizationIdController,
                                              latlng: geopointController.text));
                                    }
                                  });
                            },
                          ),
                          SizedBox(
                            width: Constants.defaultPadding * 0.5,
                          ),
                          CustomElevatedButton(
                              text: "Отмена",
                              width: 110,
                              height: 43,
                              alternativeStyle: true,
                              fontSize: Constants.textTheme.bodyLarge!.fontSize,
                              function: () {
                                Navigator.of(context).pop();
                              })
                        ],
                      )
                    ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
