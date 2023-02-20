import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pikapika_admin_panel/data/models/promotion.dart';
import 'package:pikapika_admin_panel/logic/blocs/promotion/promotion_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

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

  List<DataRow> getRows(BuildContext context, List<Promotion> promotions) {
    return promotions.map((e) {
      var description = e.description.length > 90
          ? "${e.description.substring(0, 89)}..."
          : e.description;
      return DataRow(
          onSelectChanged: (value) {
            showPromotionDialog(context, context.read<PromotionBloc>(), e);
          },
          cells: [
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              width: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(13)),
                child: CachedNetworkImage(
                  imageUrl: e.imageUrl,
                  placeholder: (context, url) => const SizedBox.shrink(),
                ),
              ),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.title),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.order.toString()),
            )),
            DataCell(Container(
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.promocode),
            )),
            DataCell(Container(
              width: 200,
              padding: const EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(description),
            )),
          ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    var columns = [
      "Изображение",
      "Заголовок",
      "Порядок",
      "Промокод",
      "Описание"
    ];

    List<DataRow> rows = [];

    return BlocBuilder<PromotionBloc, PromotionState>(
      builder: (context1, state) {
        if (state is PromotionInitialState || state is PromotionLoadingState) {
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
        if (state is PromotionLoadedState) {
          rows = getRows(context1, state.promotions);
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
                      text: "Добавить акцию",
                      width: 150,
                      height: 43,
                      fontSize: Constants.textTheme.bodyLarge!.fontSize,
                      function: () {
                        showPromotionDialog(
                            context1, context1.read<PromotionBloc>(), null);
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
                          "Акции и предложения",
                          style: Constants.textTheme.headlineMedium,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: Constants.defaultPadding * 1.5),
                        child: Text(
                          "Акционные предложения ресторана",
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
          ),
        );
      },
    );
  }

  //Show special dialog window for editing or adding a new one
  void showPromotionDialog(
      BuildContext context, PromotionBloc promotionBloc, Promotion? promotion) {
    var titleController = promotion == null
        ? TextEditingController()
        : TextEditingController(text: promotion.title);
    var orderController = promotion == null
        ? TextEditingController()
        : TextEditingController(text: promotion.order.toString());
    var promocodeController = promotion == null
        ? TextEditingController()
        : TextEditingController(text: promotion.promocode);
    var imageUrlController = promotion == null
        ? TextEditingController()
        : TextEditingController(text: promotion.imageUrl);
    var descriptionController = promotion == null
        ? TextEditingController()
        : TextEditingController(text: promotion.description);
    showDialog(
        context: context,
        builder: (context2) {
          return ScaffoldMessenger(
            child: Builder(builder: (context3) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Dialog(
                  insetPadding:
                      const EdgeInsets.all(Constants.defaultPadding * 0.5),
                  backgroundColor: Colors.transparent,
                  child: BlocProvider.value(
                    value: promotionBloc,
                    child: SingleChildScrollView(
                      child: Container(
                        width: 600,
                        padding: const EdgeInsets.symmetric(
                            horizontal: Constants.defaultPadding,
                            vertical: Constants.defaultPadding * 1.75),
                        decoration: const BoxDecoration(
                            color: Constants.secondBackgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 0.5),
                                child: SizedBox(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        promotion == null
                                            ? "Добавление новой акции"
                                            : "Редактирование акции",
                                        style: Constants.textTheme.displaySmall,
                                      ),
                                      promotion != null
                                          ? BlocBuilder<PromotionBloc,
                                              PromotionState>(
                                              builder: (context, state) {
                                                if (state
                                                    is PromotionDeletingState) {
                                                  return Container(
                                                    margin: const EdgeInsets
                                                            .only(
                                                        right: Constants
                                                                .defaultPadding *
                                                            0.5),
                                                    width: 15,
                                                    height: 15,
                                                    child:
                                                        const CircularProgressIndicator(
                                                      strokeWidth: 1.5,
                                                      color: Constants
                                                          .secondPrimaryColor,
                                                    ),
                                                  );
                                                }
                                                return TextButton(
                                                  style: TextButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/trash.svg',
                                                    color: Constants
                                                        .secondPrimaryColor,
                                                    width: 15,
                                                  ),
                                                  onPressed: () {
                                                    promotionBloc.add(
                                                        DeletePromotion(
                                                            id: promotion.id));
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
                                padding: const EdgeInsets.only(
                                    bottom: Constants.defaultPadding * 1.5),
                                child: Text(
                                  promotion == null
                                      ? "Введите все необходимые данные для добавления акции"
                                      : "Для редактирования внесите изменения и нажмите кнопку \"Сохранить\"",
                                  style: Constants.textTheme.bodyLarge!
                                      .copyWith(
                                          color: Constants.middleGrayColor),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Заголовок акции",
                                    hintText: "Введите главный заголовок акции",
                                    keyboardType: TextInputType.text,
                                    controller: titleController),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Порядок",
                                    hintText:
                                        "Введите порядковый номер акционного предложения",
                                    keyboardType: TextInputType.number,
                                    controller: orderController),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Промокод",
                                    hintText:
                                        "Введите промокод акции, если он имеется",
                                    keyboardType: TextInputType.text,
                                    controller: promocodeController),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "URL изображения акции",
                                    hintText: "Введите URL изображения",
                                    keyboardType: TextInputType.text,
                                    controller: imageUrlController),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Constants.defaultPadding,
                                ),
                                child: CustomTextInputField(
                                    titleText: "Описание",
                                    hintText: "",
                                    maxLines: 7,
                                    keyboardType: TextInputType.text,
                                    controller: descriptionController),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BlocConsumer<PromotionBloc, PromotionState>(
                                    listener: (context, state) {
                                      if (state is PromotionErrorState) {
                                        var errorSnackBar =
                                            Constants.errorSnackBar(
                                                context, state.message,
                                                duration: const Duration(
                                                    milliseconds: 1000));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(errorSnackBar);
                                      } else if (state
                                          is PromotionSuccessSaved) {
                                        ScaffoldMessenger.of(context2)
                                            .showSnackBar(
                                                Constants.successSnackBar(
                                                    context,
                                                    "Данные успешно сохранены",
                                                    duration: const Duration(
                                                        milliseconds: 1600)));

                                        Navigator.of(context).pop();
                                      } else if (state
                                          is PromotionSuccessDeleted) {
                                        ScaffoldMessenger.of(context2)
                                            .showSnackBar(
                                                Constants.successSnackBar(
                                                    context,
                                                    "Акция успешно удалена",
                                                    duration: const Duration(
                                                        milliseconds: 1600)));

                                        Navigator.of(context).pop();
                                      }
                                    },
                                    builder: (context3, state) {
                                      return CustomElevatedButton(
                                          text: "Сохранить",
                                          width: 130,
                                          isLoading:
                                              state is PromotionSavingState,
                                          height: 43,
                                          fontSize: Constants
                                              .textTheme.bodyLarge!.fontSize,
                                          function: () {
                                            //Add the new promotion
                                            if (promotion == null) {
                                              promotionBloc.add(AddPromotion(
                                                  imageUrl:
                                                      imageUrlController.text,
                                                  title: titleController.text,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  order: orderController.text,
                                                  promocode: promocodeController
                                                      .text));
                                            }
                                            //Edit the existed promotion
                                            else {
                                              promotionBloc.add(UpdatePromotion(
                                                  id: promotion.id,
                                                  imageUrl:
                                                      imageUrlController.text,
                                                  title: titleController.text,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                  order: orderController.text,
                                                  promocode: promocodeController
                                                      .text));
                                            }
                                          });
                                    },
                                  ),
                                  const SizedBox(
                                    width: Constants.defaultPadding * 0.5,
                                  ),
                                  CustomElevatedButton(
                                      text: "Отмена",
                                      width: 110,
                                      height: 43,
                                      alternativeStyle: true,
                                      fontSize: Constants
                                          .textTheme.bodyLarge!.fontSize,
                                      function: () {
                                        Navigator.of(context).pop();
                                      })
                                ],
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
