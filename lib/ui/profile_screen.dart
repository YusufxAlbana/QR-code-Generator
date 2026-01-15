import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Apple Color Palette
const Color appleBlue = Color(0xFF007AFF);
const Color appleRed = Color(0xFFFF3B30);
const Color appleGreen = Color(0xFF34C759);
const Color appleOrange = Color(0xFFFF9500);
const Color applePurple = Color(0xFF5856D6);
const Color appleGray = Color(0xFFF2F2F7);
const Color appleDarkText = Color(0xFF1C1C1E);
const Color appleSecondaryText = Color(0xFF8E8E93);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Dummy user data
  static const String _userName = 'Yusuf Nawaf Albana';
  static const String _userEmail = 'yusuf.albana@gmail.com';
  static const String _userPhone = '+62 812 3456 7890';
  static const String _userRole = 'Fullstack Developer';
  static const String _userBio = 'Passionate about creating beautiful and functional applications.';
  static const String _memberSince = 'January 2024';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appleGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, 
              color: appleDarkText, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: appleDarkText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Header Card with hover animation
              _AnimatedProfileCard(
                child: Column(
                  children: [
                    // Avatar with gradient ring
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [appleBlue, applePurple, appleRed],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage('assets/images/profile.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name
                    const Text(
                      _userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: appleDarkText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [appleBlue, applePurple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        _userRole,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Bio
                    Text(
                      _userBio,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: appleSecondaryText,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Account Information Section
              _buildSectionHeader('Account Information'),
              const SizedBox(height: 12),
              _AnimatedInfoCard(
                children: [
                  _AnimatedInfoTile(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: _userEmail,
                    iconColor: appleBlue,
                  ),
                  _buildDivider(),
                  _AnimatedInfoTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: _userPhone,
                    iconColor: appleGreen,
                  ),
                  _buildDivider(),
                  _AnimatedInfoTile(
                    icon: Icons.lock_outline_rounded,
                    label: 'Password',
                    value: '••••••••••••',
                    iconColor: appleOrange,
                    trailing: TextButton(
                      onPressed: () => _showDummySnackbar(context, 'Change password'),
                      child: Text(
                        'Change',
                        style: TextStyle(
                          color: appleBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // App Settings Section
              _buildSectionHeader('App Settings'),
              const SizedBox(height: 12),
              _AnimatedInfoCard(
                children: [
                  _AnimatedInfoTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    value: 'Enabled',
                    iconColor: appleRed,
                    trailing: Switch.adaptive(
                      value: true,
                      onChanged: (_) => _showDummySnackbar(context, 'Toggle notifications'),
                      activeColor: appleBlue,
                    ),
                  ),
                  _buildDivider(),
                  _AnimatedInfoTile(
                    icon: Icons.dark_mode_outlined,
                    label: 'Dark Mode',
                    value: 'Disabled',
                    iconColor: applePurple,
                    trailing: Switch.adaptive(
                      value: false,
                      onChanged: (_) => _showDummySnackbar(context, 'Toggle dark mode'),
                      activeColor: appleBlue,
                    ),
                  ),
                  _buildDivider(),
                  _AnimatedInfoTile(
                    icon: Icons.language_outlined,
                    label: 'Language',
                    value: 'English',
                    iconColor: appleBlue,
                    trailing: Icon(Icons.chevron_right_rounded, color: appleSecondaryText),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // About Section
              _buildSectionHeader('About'),
              const SizedBox(height: 12),
              _AnimatedInfoCard(
                children: [
                  _AnimatedInfoTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'Member Since',
                    value: _memberSince,
                    iconColor: appleGreen,
                  ),
                  _buildDivider(),
                  _AnimatedInfoTile(
                    icon: Icons.info_outline_rounded,
                    label: 'App Version',
                    value: '1.0.0',
                    iconColor: appleSecondaryText,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Logout Button with hover animation
              _AnimatedLogoutButton(
                onPressed: () => _showDummySnackbar(context, 'Logout'),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDummySnackbar(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action - This is a demo feature'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: appleDarkText,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: appleDarkText,
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
    );
  }
}

// Animated Profile Header Card
class _AnimatedProfileCard extends StatefulWidget {
  final Widget child;

  const _AnimatedProfileCard({required this.child});

  @override
  State<_AnimatedProfileCard> createState() => _AnimatedProfileCardState();
}

class _AnimatedProfileCardState extends State<_AnimatedProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered ? appleBlue.withOpacity(0.3) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? appleBlue.withOpacity(0.15) 
                    : Colors.black.withOpacity(0.05),
                blurRadius: _isHovered ? 28 : 20,
                offset: Offset(0, _isHovered ? 12 : 8),
                spreadRadius: _isHovered ? 2 : 0,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// Animated Info Card Container
class _AnimatedInfoCard extends StatefulWidget {
  final List<Widget> children;

  const _AnimatedInfoCard({required this.children});

  @override
  State<_AnimatedInfoCard> createState() => _AnimatedInfoCardState();
}

class _AnimatedInfoCardState extends State<_AnimatedInfoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? appleBlue.withOpacity(0.2) : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered 
                    ? appleBlue.withOpacity(0.1) 
                    : Colors.black.withOpacity(0.04),
                blurRadius: _isHovered ? 20 : 16,
                offset: Offset(0, _isHovered ? 6 : 4),
                spreadRadius: _isHovered ? 1 : 0,
              ),
            ],
          ),
          child: Column(children: widget.children),
        ),
      ),
    );
  }
}

// Animated Info Tile
class _AnimatedInfoTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final Widget? trailing;

  const _AnimatedInfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.trailing,
  });

  @override
  State<_AnimatedInfoTile> createState() => _AnimatedInfoTileState();
}

class _AnimatedInfoTileState extends State<_AnimatedInfoTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isHovered ? appleGray.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isHovered 
                    ? widget.iconColor.withOpacity(0.18) 
                    : widget.iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 12,
                      color: appleSecondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.value,
                    style: const TextStyle(
                      fontSize: 15,
                      color: appleDarkText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.trailing != null) widget.trailing!,
          ],
        ),
      ),
    );
  }
}

// Animated Logout Button
class _AnimatedLogoutButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedLogoutButton({required this.onPressed});

  @override
  State<_AnimatedLogoutButton> createState() => _AnimatedLogoutButtonState();
}

class _AnimatedLogoutButtonState extends State<_AnimatedLogoutButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _scale {
    if (_isPressed) return 0.95;
    if (_isHovered) return 1.03;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: appleRed,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? Colors.white.withOpacity(0.3) : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                      ? appleRed.withOpacity(0.5) 
                      : appleRed.withOpacity(0.3),
                  blurRadius: _isHovered ? 24 : 16,
                  offset: Offset(0, _isHovered ? 10 : 6),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, size: 20, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

