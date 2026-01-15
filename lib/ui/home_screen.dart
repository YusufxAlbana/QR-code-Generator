import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';

// Apple Color Palette
const Color appleBlue = Color(0xFF007AFF);
const Color appleRed = Color(0xFFFF3B30);
const Color appleGreen = Color(0xFF34C759);
const Color appleOrange = Color(0xFFFF9500);
const Color applePurple = Color(0xFF5856D6);
const Color appleGray = Color(0xFFF2F2F7);
const Color appleDarkText = Color(0xFF1C1C1E);
const Color appleSecondaryText = Color(0xFF8E8E93);

const double kDefaultPadding = 24.0;
const double kGridSpacing = 16.0;

class User {
  final String name;
  final String role;
  final String profileImagePath;

  const User({
    required this.name,
    required this.role,
    required this.profileImagePath,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const _currentUser = User(
    name: 'Yusuf Nawaf Albana',
    role: 'Fullstack Developer',
    profileImagePath: 'assets/images/profile.jpg',
  );

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  void _showAboutAppDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(28),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Center(
                      child: Icon(Icons.qr_code_scanner_rounded,
                          size: 56, color: appleBlue),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'QR S&G',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: appleDarkText,
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: appleSecondaryText,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: appleDarkText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'QR S&G is your premium all-in-one solution for generating and scanning QR codes. Designed with simplicity and aesthetics in mind.',
                      style: TextStyle(
                        color: appleSecondaryText,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: appleDarkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(Icons.palette_rounded, 'Custom Color QR Generation'),
                    _buildFeatureItem(Icons.image_rounded, 'Share & Save as Image'),
                    _buildFeatureItem(Icons.picture_as_pdf_rounded, 'Export to PDF'),
                    _buildFeatureItem(Icons.history_rounded, 'Scan History'),
                    const SizedBox(height: 28),
                    const Text(
                      'Tech Stack',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: appleDarkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildTechChip('Flutter'),
                        _buildTechChip('Dart'),
                        _buildTechChip('Mobile Scanner'),
                        _buildTechChip('Pretty QR'),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'Made with ❤️ by Yusuf Nawaf Albana',
                        style: TextStyle(
                          color: appleSecondaryText.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: appleBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: appleBlue),
          ),
          const SizedBox(width: 14),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: appleDarkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: appleGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: appleDarkText,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'QR S&G',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline_rounded, 
                color: appleDarkText, size: 20),
            ),
            onPressed: _showAboutAppDialog, 
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        // Clean Apple-style white background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFF8F8FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: const UserProfileHeader(user: HomeScreen._currentUser),
                  ),
                ),
                const SizedBox(height: 36),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to',
                          style: TextStyle(
                            fontSize: 17,
                            color: appleSecondaryText,
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'QR S&G',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: appleDarkText,
                            letterSpacing: -0.5,
                            fontFamily: 'Manrope',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: kGridSpacing,
                    crossAxisSpacing: kGridSpacing,
                    childAspectRatio: 0.9, 
                    physics: const BouncingScrollPhysics(),
                    children: [
                       _AppleMenuCard(
                        icon: Icons.qr_code_2_rounded,
                        label: 'Create',
                        description: 'Generate new QR',
                        color: appleBlue,
                        route: '/create',
                        delay: 100,
                      ),
                       _AppleMenuCard(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'Scan',
                        description: 'Scan from Camera',
                        color: appleRed,
                        route: '/scan',
                        delay: 200,
                      ),
                       _AppleMenuCard(
                        icon: Icons.share_rounded,
                        label: 'Share',
                        description: 'Share App Link',
                        color: appleGreen,
                        route: '',
                        onTap: () => Share.share(
                          'Check out QR S&G App!\nhttps://github.com/YusufxAlbana/QR-code-Generator',
                          subject: 'QR S&G - QR Code Generator & Scanner',
                        ), 
                        delay: 300,
                      ),
                       _AppleMenuCard(
                        icon: Icons.history_rounded,
                        label: 'History',
                        description: 'Your activity',
                        color: appleOrange,
                        route: '/history',
                        delay: 400,
                      ),
                    ],
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

class UserProfileHeader extends StatefulWidget {
  const UserProfileHeader({super.key, required this.user});

  final User user;

  @override
  State<UserProfileHeader> createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _scale {
    if (_isPressed) return 0.97;
    if (_isHovered) return 1.02;
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
          Navigator.pushNamed(context, '/profile');
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isHovered 
                    ? appleBlue.withOpacity(0.3) 
                    : Colors.grey.withOpacity(0.1),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered 
                      ? appleBlue.withOpacity(0.15) 
                      : Colors.black.withOpacity(0.06),
                  blurRadius: _isHovered ? 30 : 24,
                  offset: Offset(0, _isHovered ? 12 : 8),
                  spreadRadius: _isHovered ? 2 : 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Profile Avatar with gradient ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [appleBlue, applePurple, appleRed],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage(widget.user.profileImagePath),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: TextStyle(
                          fontSize: 14,
                          color: appleSecondaryText,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.user.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: appleDarkText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: appleBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.user.role,
                          style: TextStyle(
                            fontSize: 12,
                            color: appleBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Chevron indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isHovered ? appleBlue.withOpacity(0.1) : appleGray,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: _isHovered ? appleBlue : appleSecondaryText,
                    size: 20,
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

class _AppleMenuCard extends StatefulWidget {
  const _AppleMenuCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.route,
    required this.delay,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final String route;
  final int delay;
  final VoidCallback? onTap;

  @override
  State<_AppleMenuCard> createState() => _AppleMenuCardState();
}

class _AppleMenuCardState extends State<_AppleMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isPressed = false;
  bool _isHovered = false;

  double get _interactiveScale {
    if (_isPressed) return 0.95;
    if (_isHovered) return 1.03;
    return 1.0;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    // Staggered animation start
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                if (widget.onTap != null) {
                  widget.onTap!();
                } else if (widget.route.isNotEmpty) {
                  Navigator.pushNamed(context, widget.route);
                }
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: AnimatedScale(
                scale: _interactiveScale,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOutCubic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _isHovered 
                          ? widget.color.withOpacity(0.3) 
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered 
                            ? widget.color.withOpacity(0.25) 
                            : widget.color.withOpacity(0.15),
                        blurRadius: _isHovered ? 28 : 20,
                        offset: Offset(0, _isHovered ? 12 : 8),
                        spreadRadius: _isHovered ? 2 : 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _isHovered 
                              ? widget.color.withOpacity(0.18) 
                              : widget.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.color,
                          size: 28,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: appleDarkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: appleSecondaryText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
