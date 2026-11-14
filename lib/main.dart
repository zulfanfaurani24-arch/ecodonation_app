import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'services/app_state_scope.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcoDonationApp());
}

class EcoDonationApp extends StatefulWidget {
  const EcoDonationApp({super.key});

  @override
  State<EcoDonationApp> createState() => _EcoDonationAppState();
}

class _EcoDonationAppState extends State<EcoDonationApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      appState: _appState,
      child: MaterialApp(
        title: 'EcoDonation',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2E7D32),
            primary: const Color(0xFF2E7D32),
            surface: const Color(0xFFF7F4EB),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F4EB),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => DetailScreen(campaign: args),
            );
          }
          return null;
        },
      ),
    );
  }
}
