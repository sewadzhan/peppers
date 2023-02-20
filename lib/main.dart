import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pikapika_admin_panel/data/providers/auth_firebase_provider.dart';
import 'package:pikapika_admin_panel/data/repositories/auth_repository.dart';
import 'package:pikapika_admin_panel/logic/bloc_observer.dart';
import 'package:pikapika_admin_panel/logic/cubits/auth/logout_cubit.dart';
import 'package:pikapika_admin_panel/presentation/config/app_route.dart';
import 'package:pikapika_admin_panel/presentation/config/theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCHphB7II1SmtlqAin9FmO-JnDBK4cfEQo",
          appId: "1:417211985488:web:2554d5f41b6f25d972eb55",
          messagingSenderId: "417211985488",
          projectId: "pikapika-a82c0"));
  await dotenv.load(fileName: ".env");

  final AuthRepository authRepository =
      AuthRepository(AuthFirebaseProvider(FirebaseAuth.instance));
  final AuthCubit authCubit = AuthCubit(authRepository);

  runApp(BlocProvider.value(
    value: authCubit,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var isAuthenticated = context.read<AuthCubit>().state != null;

    return MaterialApp(
      title: 'Pikapika Admin Panel',
      onGenerateRoute: AppRouter().onGenerateRoute,
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.theme,
      initialRoute: isAuthenticated ? '/' : '/login',
    );
  }
}
