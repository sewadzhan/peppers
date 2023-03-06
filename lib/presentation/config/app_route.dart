import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/data/models/delivery_point.dart';
import 'package:pikapika_admin_panel/data/providers/auth_firebase_provider.dart';
import 'package:pikapika_admin_panel/data/providers/firestore_provider.dart';
import 'package:pikapika_admin_panel/data/providers/iiko_provider.dart';
import 'package:pikapika_admin_panel/data/providers/storage_provider.dart';
import 'package:pikapika_admin_panel/data/repositories/auth_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/iiko_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/storage_repository.dart';
import 'package:pikapika_admin_panel/logic/blocs/cashback/cashback_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/contact/contact_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/gift/gift_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/login/login_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/order/order_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/order_history/order_history_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/pickup_points/pickup_point_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/promocode/promocode_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/promotion/promotion_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/storage/storage_bloc.dart';
import 'package:pikapika_admin_panel/logic/blocs/user/user_bloc.dart';
import 'package:pikapika_admin_panel/logic/cubits/individual_percent/individual_percent_cubit.dart';
import 'package:pikapika_admin_panel/logic/cubits/navigation/navigation_cubit.dart';
import 'package:pikapika_admin_panel/logic/cubits/settings/settings_cubit.dart';
import 'package:pikapika_admin_panel/presentation/screens/geopoint_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/login_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/main_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/orders_history_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/storage_screen.dart';

class AppRouter {
  final AuthRepository authRepository =
      AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance));
  static final FirestoreRepository firestoreRepository =
      FirestoreRepository(FirestoreProvider(FirebaseFirestore.instance));
  final IikoRepository iikoRepository = IikoRepository(IikoProvider());
  final StorageRepository storageRepository =
      StorageRepository(StorageProvider());

  ContactBloc contactBloc = ContactBloc(firestoreRepository)
    ..add(LoadContactData());
  CashbackBloc cashbackBloc = CashbackBloc(firestoreRepository)
    ..add(LoadCashbackData());
  UserBloc userBloc = UserBloc(firestoreRepository);
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => NavigationCubit(),
                    ),
                    BlocProvider(
                      create: (context) => PromotionBloc(firestoreRepository)
                        ..add(LoadPromotionData()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          PromocodeBloc(firestoreRepository, iikoRepository)
                            ..add(LoadPromocodeData()),
                    ),
                    BlocProvider(
                        create: (context) => SettingsCubit(
                            firestoreRepository, contactBloc, cashbackBloc)),
                    BlocProvider(
                      create: (context) => PickupPointBloc(
                          firestoreRepository, iikoRepository, contactBloc)
                        ..add(LoadPickupPointData()),
                    ),
                    BlocProvider(
                      create: (context) => OrderBloc(firestoreRepository),
                    ),
                    BlocProvider(
                      create: (context) =>
                          GiftBloc(firestoreRepository, iikoRepository)
                            ..add(LoadGiftData()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          IndividualPercentCubit(firestoreRepository, userBloc),
                    ),
                    BlocProvider.value(value: cashbackBloc),
                    BlocProvider.value(value: contactBloc),
                    BlocProvider.value(value: userBloc),
                  ],
                  child: const MainScreen(),
                ));
      case "/login":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => LoginBloc(authRepository),
                  child: const LoginScreen(),
                ));
      case "/geopoint":
        return MaterialPageRoute(
            builder: (context) => GeopointScreen(
                deliveryPoint: settings.arguments as DeliveryPoint?));
      case "/orderHistory":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => OrderHistoryBloc(firestoreRepository),
                  child: OrdersHistoryScreen(
                      phoneNumber: settings.arguments as String),
                ));
      case "/storage":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      StorageBloc(storageRepository)..add(LoadStorageFiles()),
                  child: const StorageScreen(),
                ));

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => const Scaffold(body: Center(child: Text("Error!"))),
        settings: const RouteSettings(name: "/error"));
  }
}
