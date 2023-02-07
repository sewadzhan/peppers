import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/data/providers/auth_firebase_provider.dart';
import 'package:pikapika_admin_panel/data/providers/firestore_provider.dart';
import 'package:pikapika_admin_panel/data/repositories/auth_repository.dart';
import 'package:pikapika_admin_panel/data/repositories/firestore_repository.dart';
import 'package:pikapika_admin_panel/logic/blocs/login/login_bloc.dart';
import 'package:pikapika_admin_panel/logic/cubits/navigation/navigation_cubit.dart';
import 'package:pikapika_admin_panel/presentation/screens/login_screen.dart';
import 'package:pikapika_admin_panel/presentation/screens/main_screen.dart';

class AppRouter {
  final AuthRepository authRepository =
      AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance));
  final FirestoreRepository firestoreRepository =
      FirestoreRepository(FirestoreProvider(FirebaseFirestore.instance));
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NavigationCubit(),
                  child: const MainScreen(),
                ));
      case "/login":
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => LoginBloc(authRepository),
                  child: const LoginScreen(),
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