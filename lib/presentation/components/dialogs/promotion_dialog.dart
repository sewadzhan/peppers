import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peppers_admin_panel/data/models/promotion.dart';
import 'package:peppers_admin_panel/data/models/storage_files.dart';
import 'package:peppers_admin_panel/logic/blocs/promotion/promotion_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/components/custom_text_input_field.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class PromotionDialog extends StatefulWidget {
  const PromotionDialog(
      {super.key,
      required this.dialogContext,
      required this.promotionBloc,
      this.promotion});

  @override
  State<PromotionDialog> createState() => _PromotionDialogState();

  final BuildContext dialogContext;
  final PromotionBloc promotionBloc;
  final Promotion? promotion;
}

class _PromotionDialogState extends State<PromotionDialog> {
  late TextEditingController titleController;

  late TextEditingController orderController;
  late TextEditingController promocodeController;
  late TextEditingController imageUrlController;
  late TextEditingController descriptionController;
  @override
  void initState() {
    titleController = widget.promotion == null
        ? TextEditingController()
        : TextEditingController(text: widget.promotion!.title);
    orderController = widget.promotion == null
        ? TextEditingController()
        : TextEditingController(text: widget.promotion!.order.toString());
    promocodeController = widget.promotion == null
        ? TextEditingController()
        : TextEditingController(text: widget.promotion!.promocode);
    imageUrlController = widget.promotion == null
        ? TextEditingController()
        : TextEditingController(text: widget.promotion!.imageUrl);
    descriptionController = widget.promotion == null
        ? TextEditingController()
        : TextEditingController(text: widget.promotion!.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(Constants.defaultPadding * 0.5),
      backgroundColor: Colors.transparent,
      child: BlocProvider.value(
        value: widget.promotionBloc,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            padding: EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
                vertical: Constants.defaultPadding * 1.75),
            decoration: const BoxDecoration(
                color: Constants.secondBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 0.5),
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.promotion == null
                            ? "Добавление новой акции"
                            : "Редактирование акции",
                        style: Constants.textTheme.displaySmall,
                      ),
                      widget.promotion != null
                          ? BlocBuilder<PromotionBloc, PromotionState>(
                              builder: (context, state) {
                                if (state is PromotionDeletingState) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: Constants.defaultPadding * 0.5),
                                    width: 15,
                                    height: 15,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                      color: Constants.secondPrimaryColor,
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
                                    widget.promotionBloc.add(DeletePromotion(
                                        id: widget.promotion!.id));
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
                padding:
                    EdgeInsets.only(bottom: Constants.defaultPadding * 1.5),
                child: Text(
                  widget.promotion == null
                      ? "Введите все необходимые данные для добавления акции"
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
                    titleText: "Заголовок акции",
                    hintText: "Введите главный заголовок акции",
                    keyboardType: TextInputType.text,
                    controller: titleController),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding,
                ),
                child: CustomTextInputField(
                    titleText: "Порядок",
                    hintText: "Введите порядковый номер акционного предложения",
                    keyboardType: TextInputType.number,
                    controller: orderController),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: Constants.defaultPadding,
                ),
                child: CustomTextInputField(
                    titleText: "Промокод",
                    hintText: "Введите промокод акции, если он имеется",
                    keyboardType: TextInputType.text,
                    controller: promocodeController),
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
                          titleText: "URL изображения акции",
                          hintText: "Введите URL изображения",
                          controller: imageUrlController),
                    ),
                    SizedBox(
                      width: Constants.defaultPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomElevatedButton(
                          width: 120,
                          text: "Выбрать",
                          fontSize: Constants.textTheme.bodyMedium!.fontSize,
                          backgroundColor: Constants.secondPrimaryColor,
                          function: () async {
                            var selectedFile =
                                await Navigator.pushNamed(context, '/storage');

                            if (selectedFile != null) {
                              setState(() {
                                imageUrlController = TextEditingController(
                                    text: (selectedFile as StorageFile).url);
                              });
                            }
                          }),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
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
                        var errorSnackBar = Constants.errorSnackBar(
                            context, state.message,
                            duration: const Duration(milliseconds: 1000));
                        ScaffoldMessenger.of(context)
                            .showSnackBar(errorSnackBar);
                      } else if (state is PromotionSuccessSaved) {
                        ScaffoldMessenger.of(widget.dialogContext).showSnackBar(
                            Constants.successSnackBar(
                                context, "Данные успешно сохранены",
                                duration: const Duration(milliseconds: 1600)));

                        Navigator.of(context).pop();
                      } else if (state is PromotionSuccessDeleted) {
                        ScaffoldMessenger.of(widget.dialogContext).showSnackBar(
                            Constants.successSnackBar(
                                context, "Акция успешно удалена",
                                duration: const Duration(milliseconds: 1600)));

                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context3, state) {
                      return CustomElevatedButton(
                          text: "Сохранить",
                          width: 130,
                          isLoading: state is PromotionSavingState,
                          height: 43,
                          fontSize: Constants.textTheme.bodyLarge!.fontSize,
                          function: () {
                            //Add the new promotion
                            if (widget.promotion == null) {
                              widget.promotionBloc.add(AddPromotion(
                                  imageUrl: imageUrlController.text,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  order: orderController.text,
                                  promocode: promocodeController.text));
                            }
                            //Edit the existed promotion
                            else {
                              widget.promotionBloc.add(UpdatePromotion(
                                  id: widget.promotion!.id,
                                  imageUrl: imageUrlController.text,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                  order: orderController.text,
                                  promocode: promocodeController.text));
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
  }
}
