import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pikapika_admin_panel/data/models/promotion.dart';
import 'package:pikapika_admin_panel/data/models/storage_files.dart';
import 'package:pikapika_admin_panel/logic/blocs/promotion/promotion_bloc.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:pikapika_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:pikapika_admin_panel/presentation/components/dialogs/promotion_dialog.dart';
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
              padding: EdgeInsets.symmetric(
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
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.title),
            )),
            DataCell(Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.order.toString()),
            )),
            DataCell(Container(
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Text(e.promocode),
            )),
            DataCell(Container(
              width: 200,
              padding: EdgeInsets.symmetric(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: Constants.defaultPadding * 0.5,
                    right: Constants.defaultPadding * 1.5,
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
                        "Акции и предложения",
                        style: Constants.textTheme.headlineMedium,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
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
        );
      },
    );
  }

  //Show special dialog window for editing or adding a new one
  void showPromotionDialog(
      BuildContext context, PromotionBloc promotionBloc, Promotion? promotion) {
    showDialog(
        context: context,
        builder: (context2) {
          return ScaffoldMessenger(
            child: Builder(builder: (context3) {
              return Scaffold(
                  backgroundColor: Colors.transparent,
                  body: PromotionDialog(
                    dialogContext: context2,
                    promotionBloc: promotionBloc,
                    promotion: promotion,
                  ));
            }),
          );
        });
  }
}
