import 'package:flutter/material.dart';
import 'admin_sidebar.dart';

class AdminShell extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const AdminShell({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar - visible en desktop
          if (MediaQuery.of(context).size.width >= 768)
            AdminSidebar(
              currentRoute: currentRoute,
              onClose: () {},
            )
          else
            // Mobile: mostrar sidebar como drawer
            Container(),
          
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Top bar
                Container(
                  height: 64,
                  color: Colors.white,
                  child: Row(
                    children: [
                      // Menu button para mobile
                      if (MediaQuery.of(context).size.width < 768)
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _getTitle(currentRoute),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      
                      // Spacer y acciones
                      IconButton(
                        icon: Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.settings_outlined),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                // Contenido de la página
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
      // Drawer para mobile
      drawer: MediaQuery.of(context).size.width < 768
          ? Drawer(
              child: AdminSidebar(
                currentRoute: currentRoute,
                onClose: () => Navigator.pop(context),
              ),
            )
          : null,
    );
  }

  String _getTitle(String route) {
    switch (route) {
      case '/dashboard':
        return 'Dashboard';
      case '/rutas':
        return 'Gestión de Rutas';
      case '/choferes':
        return 'Gestión de Choferes';
      case '/vehiculos':
        return 'Gestión de Vehículos';
      case '/mapa':
        return 'Mapa en Vivo';
      case '/reportes':
        return 'Reportes';
      default:
        return 'Panel de Administración';
    }
  }
}