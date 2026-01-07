import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_system_2/providers/auth_provider.dart';
import 'package:wallet_system_2/screens/auth_screens/intro_screen.dart';
import 'package:wallet_system_2/screens/auth_screens/splash_screen.dart';
import 'package:wallet_system_2/screens/handling_screens/loading_screen.dart';
import 'package:wallet_system_2/screens/main_screens/tabs_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wallet System 2',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: SplashScreen(),
      ),
    );
  }
}

class ScreenRouter extends StatefulWidget {
  const ScreenRouter({super.key});

  @override
  State<ScreenRouter> createState() => _ScreenRouterState();
}

class _ScreenRouterState extends State<ScreenRouter> {
  @override
  void initState() {
    Provider.of<AuthProvider>(context, listen: false).initAuthProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authConsumer, _) {
        return authConsumer.status == AuthStatus.authenticated
            ? TabsScreen()
            : authConsumer.status == AuthStatus.unauthenticated
            ? IntroScreen()
            : authConsumer.status == AuthStatus.authenticating
            ? LoadingScreen()
            : LoadingScreen();
      },
    );
  }
}
