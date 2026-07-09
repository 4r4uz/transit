import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'web/providers/auth_provider.dart';
import 'web/providers/dashboard_provider.dart';
import 'web/providers/rutas_provider.dart';
import 'web/providers/choferes_provider.dart';
import 'web/providers/vehiculos_provider.dart';
import 'web/providers/mapa_provider.dart';
import 'web/providers/horarios_provider.dart';
import 'web/screens/login.dart';
import 'web/screens/dashboard_screen.dart';
import 'web/screens/rutas_screen.dart';
import 'web/screens/choferes_screen.dart';
import 'web/screens/vehiculos_screen.dart';
import 'web/screens/mapa_screen.dart';
import 'web/screens/horarios_screen.dart';
import 'web/widgets/admin_shell.dart';

// Extensión para acceder a GoRouter desde el contexto
extension GoRouterExtension on BuildContext {
  GoRouter get goRouter => GoRouter.of(this);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => RutasProvider()),
        ChangeNotifierProvider(create: (_) => ChoferesProvider()),
        ChangeNotifierProvider(create: (_) => VehiculosProvider()),
        ChangeNotifierProvider(create: (_) => MapaProvider()),
        ChangeNotifierProvider(create: (_) => HorariosProvider()),
      ],
      child: MaterialApp.router(
        title: 'RuraLink - Panel Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: _router,
      ),
    );
  }

  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    refreshListenable: AuthProvider(),
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const AdminShell(
          currentRoute: '/dashboard',
          child: DashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/rutas',
        builder: (context, state) => const AdminShell(
          currentRoute: '/rutas',
          child: RutasScreen(),
        ),
      ),
      GoRoute(
        path: '/choferes',
        builder: (context, state) => const AdminShell(
          currentRoute: '/choferes',
          child: ChoferesScreen(),
        ),
      ),
      GoRoute(
        path: '/vehiculos',
        builder: (context, state) => const AdminShell(
          currentRoute: '/vehiculos',
          child: VehiculosScreen(),
        ),
      ),
      GoRoute(
        path: '/mapa',
        builder: (context, state) => const AdminShell(
          currentRoute: '/mapa',
          child: MapaScreen(),
        ),
      ),
      GoRoute(
        path: '/horarios',
        builder: (context, state) => const AdminShell(
          currentRoute: '/horarios',
          child: HorariosScreen(),
        ),
      ),
      // Rutas placeholder para funcionalidades futuras
      GoRoute(
        path: '/reportes',
        builder: (context, state) => const AdminShell(
          currentRoute: '/reportes',
          child: PlaceholderScreen(title: 'Reportes'),
        ),
      ),
    ],
  );
}

// Widget placeholder para pantallas no implementadas
class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Esta funcionalidad estará disponible próximamente',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
