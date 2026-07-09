import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends StatelessWidget {
  final String currentRoute;
  final VoidCallback onClose;

  const AdminSidebar({
    super.key,
    required this.currentRoute,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF1E293B),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Image.asset(
                  'assets/ruralink.jpeg',
                  height: 40,
                  width: 40,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RuraLink',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Panel Admin',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[700], height: 1),
          
          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 10),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  route: '/dashboard',
                  isActive: currentRoute == '/dashboard',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.route,
                  label: 'Rutas',
                  route: '/rutas',
                  isActive: currentRoute == '/rutas',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person,
                  label: 'Choferes',
                  route: '/choferes',
                  isActive: currentRoute == '/choferes',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.directions_bus,
                  label: 'Vehículos',
                  route: '/vehiculos',
                  isActive: currentRoute == '/vehiculos',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.map,
                  label: 'Mapa en vivo',
                  route: '/mapa',
                  isActive: currentRoute == '/mapa',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.schedule,
                  label: 'Horarios',
                  route: '/horarios',
                  isActive: currentRoute == '/horarios',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.assignment,
                  label: 'Reportes',
                  route: '/reportes',
                  isActive: currentRoute == '/reportes',
                ),
              ],
            ),
          ),
          
          // User info at bottom
          Divider(color: Colors.grey[700], height: 1),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administrador',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'admin@ruralink.cl',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.blue : Colors.grey[400],
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey[400],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          context.push(route);
          onClose();
        },
      ),
    );
  }
}