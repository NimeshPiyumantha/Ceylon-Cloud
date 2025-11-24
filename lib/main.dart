import 'dart:async';

import 'package:ceylon_product_app/repositories/theme/theme_manager.dart';
import 'package:ceylon_product_app/screens/splash_screen/splash_screen.dart';
import 'package:ceylon_product_app/theme/theme_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'blocs/cart/cart_bloc.dart';
import 'blocs/favorites/favorites_bloc.dart';
import 'blocs/product/product_bloc.dart';
import 'database/app_database.dart';
import 'repositories/product_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  themeManager = await ThemeManager.create();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

late ThemeManager themeManager;

class _MyAppState extends State<MyApp> {
  LogicContextThemeManager theme = LogicContextThemeManager();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final database = AppDatabase();

  @override
  void initState() {
    super.initState();
    themeManager.addListener(themeListener);

    _initConnectivityListener();
  }

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  themeListener() {
    if (mounted) setState(() {});
  }

  void _initConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        _showNoInternetMessage();
      } else {
        _removeNoInternetMessage();
      }
    });
  }

  void _showNoInternetMessage() {
    rootScaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'No Internet Connection. Please connect.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(days: 365),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }

  void _removeNoInternetMessage() {
    rootScaffoldMessengerKey.currentState?.clearSnackBars();
  }

  @override
  Widget build(BuildContext context) {
    var productRepository = ProductRepository(database);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (context) => productRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProductBloc(productRepository)),
          BlocProvider(create: (context) => CartBloc()),
          BlocProvider(create: (context) => FavoritesBloc()),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          title: 'Ceylon Cloud',
          debugShowCheckedModeBanner: false,
          theme: theme.lightTheme,
          darkTheme: theme.darkTheme,
          themeMode: themeManager.themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
