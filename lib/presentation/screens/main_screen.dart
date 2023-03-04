import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pikapika_admin_panel/logic/blocs/order/order_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/user/user_bloc.dart';
import 'package:pikapika_admin_panel/logic/cubits/auth/logout_cubit.dart';
import 'package:pikapika_admin_panel/logic/cubits/navigation/navigation_cubit.dart';
import 'package:pikapika_admin_panel/presentation/components/drawer_list_tile.dart';
import 'package:pikapika_admin_panel/presentation/config/constants.dart';
import 'package:pikapika_admin_panel/presentation/screens/contacts_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/discount_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/gift_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/orders_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/pickup_points_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/promotions_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/settings_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/users_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        leadingWidth: 150,
        backgroundColor: Constants.secondBackgroundColor,
        elevation: 0.7,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Constants.defaultPadding),
              child: SvgPicture.asset(
                'assets/logo/horizontal_logo.svg',
                width: 130,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Constants.defaultPadding),
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
              Expanded(
                  child: Drawer(
                elevation: 0,
                backgroundColor: Constants.secondBackgroundColor,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: Constants.defaultPadding),
                    child: Column(
                      children: [
                        DrawerListTile(
                          isActive: state == 0,
                          iconPath: "assets/icons/info.svg",
                          title: "Контакная информация",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(0);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 1,
                          iconPath: "assets/icons/promo.svg",
                          title: "Акции и предложения",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(1);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 2,
                          iconPath: "assets/icons/discount.svg",
                          title: "Промокоды и скидки",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(2);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 3,
                          iconPath: "assets/icons/settings.svg",
                          title: "Настройки",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(3);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 4,
                          iconPath: "assets/icons/marker.svg",
                          title: "Точки самовывоза",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(4);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 5,
                          iconPath: "assets/icons/orders.svg",
                          title: "Заказы",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(5);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 6,
                          iconPath: "assets/icons/gift.svg",
                          title: "Подарки",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(6);
                          },
                        ),
                        DrawerListTile(
                          isActive: state == 7,
                          iconPath: "assets/icons/user.svg",
                          title: "Пользователи",
                          onTap: () {
                            context.read<NavigationCubit>().setIndex(7);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )),
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
