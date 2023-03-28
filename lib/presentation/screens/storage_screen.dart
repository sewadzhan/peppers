import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peppers_admin_panel/data/models/storage_files.dart';
import 'package:peppers_admin_panel/logic/blocs/storage/storage_bloc.dart';
import 'package:peppers_admin_panel/presentation/components/custom_elevated_button.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';
import 'package:peppers_admin_panel/presentation/config/responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  StorageFile? selectedFile;
  late List<StorageFile> storageFiles = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Constants.secondBackgroundColor,
          foregroundColor: Constants.darkGrayColor,
          elevation: 0.5,
          toolbarHeight: 70,
          title: Text(
            "Выберите изображение",
            style: Constants.textTheme.displaySmall,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(
                  top: Constants.defaultPadding * 0.5,
                  right: Constants.defaultPadding,
                  bottom: Constants.defaultPadding * 0.5),
              child: CustomElevatedButton(
                  width: 150,
                  alternativeStyle: true,
                  fontSize: Constants.textTheme.headlineSmall!.fontSize,
                  text: "Загрузить",
                  function: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (result != null) {
                      context.read<StorageBloc>().add(UploadStorageFile(
                          result.files.single.bytes!,
                          result.files.single.name));
                    }
                  }),
            )
          ],
        ),
        floatingActionButton: selectedFile != null
            ? FloatingActionButton(
                backgroundColor: Constants.primaryColor,
                foregroundColor: Constants.buttonTextColor,
                onPressed: () {
                  Navigator.of(context).pop(selectedFile);
                },
                child: const Icon(
                  Icons.done,
                ),
              )
            : const SizedBox.shrink(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: BlocConsumer<StorageBloc, StorageState>(
                  listener: (context, state) {
                    if (state is StorageErrorState) {
                      var errorSnackBar = Constants.errorSnackBar(
                          context, state.message,
                          duration: const Duration(milliseconds: 7000));
                      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
                    } else if (state is StorageUploading ||
                        state is StorageDeleting) {
                      var loadingSnackBar = Constants.loadingSnackBar(context,
                          title: state is StorageUploading
                              ? "Загрузка изображения..."
                              : "Удаление изображения...");
                      ScaffoldMessenger.of(context)
                          .showSnackBar(loadingSnackBar);
                    } else if (state is StorageSuccessUploaded) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      var successSnackBar = Constants.successSnackBar(
                          context, "Изображение успешно загружено",
                          duration: const Duration(milliseconds: 1000));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successSnackBar);
                    } else if (state is StorageFileSuccessDeleted) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      var successSnackBar = Constants.successSnackBar(
                          context, "Изображение успешно удалено",
                          duration: const Duration(milliseconds: 1000));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(successSnackBar);
                      setState(() {
                        selectedFile = null;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is StorageInitial ||
                        state is StorageLoading ||
                        state is StorageErrorState) {
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
                    if (state is StorageLoaded) {
                      storageFiles = state.storageFiles;
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                          left: Constants.defaultPadding * 0.75,
                          top: Constants.defaultPadding * 0.75),
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Constants.getCrossAxisCount(
                              MediaQuery.of(context).size.width,
                            ),
                          ),
                          itemCount: storageFiles.length,
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedFile = storageFiles[index];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: selectedFile?.url ==
                                                  storageFiles[index].url
                                              ? Constants.primaryColor
                                              : Colors.transparent,
                                          width: 3)),
                                  margin: EdgeInsets.only(
                                      right: Constants.defaultPadding * 0.75,
                                      bottom: Constants.defaultPadding * 0.75),
                                  child: CachedNetworkImage(
                                    imageUrl: storageFiles[index].url,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )),
                    );
                  },
                ),
              ),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 70,
                        color: Constants.secondBackgroundColor,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: Constants.defaultPadding,
                                left: Constants.defaultPadding * 0.75,
                                right: Constants.defaultPadding * 0.75),
                            child: Column(
                              children: [
                                selectedFile != null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: Constants.defaultPadding *
                                                    1.25,
                                                bottom:
                                                    Constants.defaultPadding *
                                                        0.75),
                                            child: Text(
                                              "Параметры изображения",
                                              style: Constants
                                                  .textTheme.headlineSmall,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    Constants.defaultPadding *
                                                        0.75),
                                            child: CachedNetworkImage(
                                              imageUrl: selectedFile!.url,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    Constants.defaultPadding *
                                                        0.5),
                                            child: Text(
                                              selectedFile!.name,
                                              style: Constants
                                                  .textTheme.titleLarge,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    Constants.defaultPadding *
                                                        0.5),
                                            child: InkWell(
                                              onTap: () {
                                                launchUrl(Uri.parse(
                                                    selectedFile!.url));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                    child: SvgPicture.asset(
                                                        'assets/icons/link.svg'),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                      child: Text(
                                                          "URL изображения",
                                                          style: Constants
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  color: Constants
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline)))
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom:
                                                    Constants.defaultPadding),
                                            child: InkWell(
                                              onTap: () {
                                                context.read<StorageBloc>().add(
                                                    DeleteStorageFile(
                                                        selectedFile!.name));
                                              },
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 15,
                                                    child: SvgPicture.asset(
                                                      'assets/icons/trash.svg',
                                                      color: Constants
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                      child: Text(
                                                          "Удалить изображение",
                                                          style: Constants
                                                              .textTheme
                                                              .titleLarge!
                                                              .copyWith(
                                                                  color: Constants
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline)))
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
