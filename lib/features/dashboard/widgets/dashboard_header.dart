// ============================================================================
// DASHBOARD HEADER WIDGET
// ============================================================================
// Header dashboard dengan welcome message, profile, dan notification
// ============================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'dashboard_constants.dart';
import 'dashboard_reusable_widgets.dart';
import '../notification_popup.dart';

/// Header dashboard dengan profil user dan notifikasi
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    this.userName = 'Admin Diana',
    this.userAvatar,
    this.onSearchTap,
    this.onNotificationTap,
  });

  final String userName;
  final String? userAvatar;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileAvatar(imageUrl: userAvatar),
        const SizedBox(width: DashboardSpacing.lg),
        Expanded(
          child: _WelcomeText(userName: userName),
        ),
        DashboardIconButton(
          icon: Icons.search,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          iconColor: Colors.white,
          onTap: onSearchTap,
        ),
        const SizedBox(width: DashboardSpacing.md),
        DashboardIconButton(
          icon: Icons.notifications_outlined,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          iconColor: Colors.white,
          showBadge: true,
          onTap: () => _showNotificationPopup(context),
        ),
      ],
    );
  }

  void _showNotificationPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 80,
              right: 20,
              child: Material(
                color: Colors.transparent,
                child: const NotificationPopup(),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Avatar profil user dengan border
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundImage: imageUrl != null
            ? AssetImage(imageUrl!)
            : const AssetImage('assets/illustrations/LOGIN.png'),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }
}

/// Welcome text dengan nama user
class _WelcomeText extends StatelessWidget {
  const _WelcomeText({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          'Selamat Datang 👋',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          maxLines: 1,
          minFontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        AutoSizeText(
          userName,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          maxLines: 1,
          minFontSize: 16,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

