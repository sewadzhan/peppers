import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pikapika_admin_panel/data/models/pikapika_user.dart';
import 'package:pikapika_admin_panel/logic/blocs/user/user_bloc.dart';
import 'package:pikapika_admin_panel/logic/cubits/individual_percent/individual_percent_cubit.dart';
import 'package:pikapika_admin_panel/presentation/components/dialogs/user_dialog.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  List<DataColumn> getColumns() {
    var columns = [
      "Номер телефона",
      "Имя",
      "Email",
      "Дата рождения",
      "Количество баллов"
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
    return BlocListener<IndividualPercentCubit, IndividualPercentState>(
      listener: (context, percentState) {
        if (percentState is IndividualPercentSuccessSaved) {
          Navigator.pop(context);
          var successSnackBar = Constants.successSnackBar(
              context, "Данные успешно сохранены",
              duration: const Duration(milliseconds: 1600));
          ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context1, state) {
          if (state is UserInitialState || state is UserLoadingState) {
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
          if (state is UserLoadedState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Expanded(
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
                              "Пользователи",
                              style: Constants.textTheme.headlineMedium,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: Constants.defaultPadding * 1.5),
                            child: Text(
                              "Все пользователи мобильного приложения ресторана",
                              style: Constants.textTheme.bodyLarge!
                                  .copyWith(color: Constants.middleGrayColor),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: PaginatedDataTable(
                              rowsPerPage: 15,
                              source: UserData(state.users, context,
                                  context.read<IndividualPercentCubit>()),
                              showCheckboxColumn: false,
                              horizontalMargin: 10,
                              dataRowHeight: 60,
                              columnSpacing: 35,
                              columns: getColumns(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class UserData extends DataTableSource {
  final List<PikapikaUser> users;
  final BuildContext context;
  final IndividualPercentCubit individualPercentCubit;

  UserData(this.users, this.context, this.individualPercentCubit);

  //Show special dialog window for editing or adding a new one
  void showUserDialog(BuildContext context, PikapikaUser user,
      IndividualPercentCubit individualPercentCubit) {
    showDialog(
        context: context,
        builder: (context2) {
          return BlocProvider.value(
            value: individualPercentCubit,
            child: UserDialog(
              user: user,
            ),
          );
        });
  }

  @override
  DataRow? getRow(int index) {
    return DataRow(
        onSelectChanged: (value) {
          showUserDialog(context, users[index], individualPercentCubit);
        },
        cells: [
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              users[index].phoneNumber,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              users[index].name,
            ),
          )),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              users[index].email,
            ),
          )),
          DataCell(Container(
            padding:
                EdgeInsets.symmetric(vertical: Constants.defaultPadding * 0.5),
            child: Text(
              users[index].birthday,
            ),
          )),
          DataCell(Container(
              width: 350,
              padding: EdgeInsets.symmetric(
                  vertical: Constants.defaultPadding * 0.5),
              child: Row(
                children: [
                  Text(users[index].cashback.toString(),
                      style: Constants.textTheme.bodyLarge!.copyWith(
                          fontSize: 18, color: Constants.primaryColor)),
                  const SizedBox(width: 5),
                  SvgPicture.asset(
                    "assets/icons/pikapika.svg",
                    width: 20,
                    color: Constants.primaryColor,
                  )
                ],
              ))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
}
