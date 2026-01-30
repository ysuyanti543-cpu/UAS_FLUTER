import 'package:flutter/material.dart';

import '../models.dart';
import '../pages/seller_page.dart';
import '../pages/manage_user_page.dart';

/// Reusable grid of service cards. Pass the [role] to conditionally show admin-only items.
class ServiceMenu extends StatelessWidget {
  final UserRole role;
  const ServiceMenu({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      // physics dihapus supaya tidak overflow
      childAspectRatio: 3 / 2,
      children: [
        // UMKM - available to all
        _ServiceCard(
          icon: Icons.store,
          title: 'UMKM',
          subtitle: 'Data UMKM',
          color: Colors.orange,
          onTap: () {
            Navigator.pushNamed(context, SellerPage.routeName);
          },
        ),

        // ASPIRASI - available to all
        _ServiceCard(
          icon: Icons.assignment_outlined,
          title: 'Aspirasi',
          subtitle: 'Pengajuan Aspirasi Rakyat',
          color: Theme.of(context).colorScheme.primary,
          onTap: () {
            Navigator.pushNamed(context, '/layanan');
          },
        ),

        // Admin-only
        if (role == UserRole.admin)
          _ServiceCard(
            icon: Icons.admin_panel_settings,
            title: 'Manajemen User',
            subtitle: 'Petugas & Admin',
            color: Colors.red,
            onTap: () {
              Navigator.pushNamed(context, ManageUserPage.routeName);
            },
          ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.12 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
