import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'config.dart';
import 'providers/auth.dart';
import 'screens/dashboard.dart';
import 'screens/login.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Load the environment variables from the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();

  void onSessionSelected(Session session) {
    if (isValidSession(session)) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Logged in! Redirecting to the dashboard.'),
        ),
      );
    }
  }

  void onSessionCleared(Session session) {
    navigatorKey.currentState?.pushReplacementNamed('/');

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('Logged out. Please login again.'),
      ),
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => TurnkeyProvider(
                config: TurnkeyConfig(
                    apiBaseUrl: EnvConfig.turnkeyApiUrl,
                    organizationId: EnvConfig.organizationId,
                    onSessionSelected: onSessionSelected,
                    onSessionCleared: onSessionCleared))),
        ChangeNotifierProxyProvider<TurnkeyProvider, AuthRelayerProvider>(
          create: (context) => AuthRelayerProvider(
              turnkeyProvider:
                  Provider.of<TurnkeyProvider>(context, listen: false)),
          update: (context, turnkeyProvider, previous) =>
              AuthRelayerProvider(turnkeyProvider: turnkeyProvider),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: '{{name}}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 26, 255)),
        useMaterial3: true,
      ),
      home: const HomePage(title: '{{name}}'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final authRelayerProvider =
        Provider.of<AuthRelayerProvider>(context, listen: false);

    void showAuthRelayerProviderErrors() {
      if (authRelayerProvider.errorMessage != null) {
        debugPrint(authRelayerProvider.errorMessage.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'An error has occurred: \n${authRelayerProvider.errorMessage.toString()}'),
          ),
        );

        authRelayerProvider.setError(null);
      }
    }

    authRelayerProvider.addListener(showAuthRelayerProviderErrors);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: LoginScreen());
  }
}
