import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pikapika_admin_panel/logic/cubits/auth/logout_cubit.dart';
import 'package:pikapika_admin_panel/presentation/components/drawer_list_tile.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
        children: [
          Expanded(
              child: Drawer(
            backgroundColor: Constants.primaryColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerHeader(
                    child: SvgPicture.asset(
                      'assets/logo/horizontal_logo.svg',
                      color: Constants.whiteColor,
                    ),
                  ),
                  DrawerListTile(
                    icon: FontAwesomeIcons.house,
                    title: "Главная",
                    onTap: () {},
                  ),
                  DrawerListTile(
                    icon: FontAwesomeIcons.addressBook,
                    title: "Контакная информация",
                    onTap: () {},
                  ),
                  DrawerListTile(
                    icon: FontAwesomeIcons.bullhorn,
                    title: "Акции",
                    onTap: () {},
                  ),
                  DrawerListTile(
                    icon: FontAwesomeIcons.tags,
                    title: "Промокоды",
                    onTap: () {},
                  ),
                  DrawerListTile(
                    icon: FontAwesomeIcons.tags,
                    title: "Выход",
                    onTap: () {
                      context.read<AuthCubit>().signOut();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/login');
                    },
                  )
                ],
              ),
            ),
          )),
          Expanded(
              flex: 5,
              child: Container(
                color: Colors.blue,
              )),
        ],
      )),
    );
  }
}
