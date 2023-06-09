import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peppers_admin_panel/logic/blocs/order/order_bloc.dart';
import 'package:peppers_admin_panel/logic/blocs/user/user_bloc.dart';
import 'package:peppers_admin_panel/logic/cubits/auth/logout_cubit.dart';
import 'package:peppers_admin_panel/logic/cubits/navigation/navigation_cubit.dart';
import 'package:peppers_admin_panel/presentation/components/drawer_list_tile.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';
import 'package:peppers_admin_panel/presentation/config/responsive.dart';
import 'package:peppers_admin_panel/presentation/screens/contacts_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/discount_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/gift_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/orders_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/pickup_points_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/promotions_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/settings_screen.dart';
import 'package:peppers_admin_panel/presentation/screens/users_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //Changing theme for small devices
    Constants.checkThemeForSmallDevices(MediaQuery.of(context).size.width);

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
    final screens = [
      const ContactsScreen(),
      const PromotionScreen(),
      const DiscountScreen(),
      const SettingsScreen(),
      const PickupPointsScreen(),
      const OrdersScreen(),
      const GiftScreen(),
      const UsersScreen()
    ];

    context.read<OrderBloc>().add(LoadOrders());
    context.read<UserBloc>().add(LoadUsers());

    return Scaffold(
      key: scaffoldKey,
      drawer: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return SideMenu(
            state,
            scaffoldKey: scaffoldKey,
            isNotDesktop: true,
          );
        },
      ),
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        leadingWidth: !Responsive.isDesktop(context) ? 200 : 150,
        backgroundColor: Constants.secondBackgroundColor,
        elevation: 0.7,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !Responsive.isDesktop(context)
                ? IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Constants.primaryColor,
                    ))
                : const SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.only(left: Constants.defaultPadding),
              child: SvgPicture.asset(
                'assets/logo/logo.svg',
                width: 130,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Constants.defaultPadding),
            child: PopupMenuButton(
              tooltip: "",
              splashRadius: 1,
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == "signOut") {
                  context.read<AuthCubit>().signOut();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/login');
                }
              },
              icon: CircleAvatar(
                backgroundColor: Constants.backgroundColor,
                child: SvgPicture.asset(
                  'assets/icons/user.svg',
                  color: Constants.middleGrayColor,
                  width: 15,
                ),
              ),
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context1) {
                return [
                  PopupMenuItem<String>(
                    value: "signOut",
                    child: Text(
                      "Выйти из аккаунта",
                      style: Constants.textTheme.bodyLarge,
                    ),
                  )
                ];
              },
            ),
          )
        ],
      ),
      body: SafeArea(child: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return Row(
            children: [
              Responsive.isDesktop(context)
                  ? Expanded(
                      child: SideMenu(
                        state,
                        scaffoldKey: scaffoldKey,
                        isNotDesktop: false,
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(
                  flex: 5,
                  child: IndexedStack(
                    index: state,
                    children: screens,
                  )),
            ],
          );
        },
      )),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu(
    this.state, {
    super.key,
    required this.scaffoldKey,
    required this.isNotDesktop,
  });

  final int state;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isNotDesktop;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: Constants.secondBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: Constants.defaultPadding),
          child: Column(
            children: [
              DrawerListTile(
                isActive: state == 0,
                iconPath: "assets/icons/info.svg",
                title: "Контакная информация",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(0);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 1,
                iconPath: "assets/icons/promo.svg",
                title: "Акции и предложения",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(1);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 2,
                iconPath: "assets/icons/discount.svg",
                title: "Промокоды и скидки",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(2);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 3,
                iconPath: "assets/icons/settings.svg",
                title: "Настройки",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(3);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 4,
                iconPath: "assets/icons/marker.svg",
                title: "Точки самовывоза",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(4);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 5,
                iconPath: "assets/icons/orders.svg",
                title: "Заказы",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(5);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 6,
                iconPath: "assets/icons/gift.svg",
                title: "Подарки",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(6);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
              DrawerListTile(
                isActive: state == 7,
                iconPath: "assets/icons/user.svg",
                title: "Пользователи",
                onTap: () {
                  context.read<NavigationCubit>().setIndex(7);
                  if (isNotDesktop) {
                    scaffoldKey.currentState!.closeDrawer();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
