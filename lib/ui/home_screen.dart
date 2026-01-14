import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

const double kDefaultPadding = 24.0;
const double kGridSpacing = 20.0;
const Color primaryColor = Color(0xFF3A2EC3);

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
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));

    _controller.forward();
  }

  void _showAboutAppDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(30),
                physics: const BouncingScrollPhysics(),
                children: [
                  const Center(
                    child: Icon(Icons.qr_code_scanner_rounded,
                        size: 64, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'QR S&G',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'v1.0.0',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'About App',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'QR S&G is your premium all-in-one solution for generating and scanning QR codes. Designed with simplicity and aesthetics in mind.',
                    style: TextStyle(color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Key Features',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(Icons.palette_rounded, 'Custom Color QR Generation'),
                  _buildFeatureItem(Icons.image_rounded, 'Share & Save as Image'),
                  _buildFeatureItem(Icons.picture_as_pdf_rounded, 'Export to PDF'),
                  _buildFeatureItem(Icons.history_rounded, 'Scan History (Coming Soon)'),
                  
                  const SizedBox(height: 24),
                  const Text(
                    'Tech Stack',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      _buildTechChip('Share Plus'),
                      _buildTechChip('Printing'),
                      _buildTechChip('GetIt'),
                      _buildTechChip('Google Fonts'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Made with ❤️ by Yusuf Nawaf Albana',
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
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
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Icon(Icons.info_outline_rounded, color: Colors.black87),
            ),
            onPressed: _showAboutAppDialog, 
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // 1. Static Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF3F4F6),
                  Color(0xFFE5E7EB),
                  Color(0xFFF0FDF4),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 150,
            child: _RGBBottomGlow(),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: const UserProfileHeader(user: HomeScreen._currentUser),
                    ),
                  ),
                  const SizedBox(height: 40),
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
                              fontSize: 20,
                              color: Colors.grey.shade600,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'QR S&G',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F2937),
                              letterSpacing: -0.5,
                              fontFamily: 'Manrope',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: kGridSpacing,
                      crossAxisSpacing: kGridSpacing,
                      childAspectRatio: 0.85, 
                      physics: const BouncingScrollPhysics(),
                      children: [
                         _AnimatedMenuCard(
                          icon: Icons.qr_code_2_rounded,
                          label: 'Create',
                          description: 'Generate new QR',
                          color: Color(0xFF4B68FF),
                          route: '/create',
                          delay: 200,
                        ),
                         _AnimatedMenuCard(
                          icon: Icons.qr_code_scanner_rounded,
                          label: 'Scan',
                          description: 'Scan from Camera',
                          color: Color(0xFFFF4B4B),
                          route: '/scan',
                          delay: 400,
                        ),
                         _AnimatedMenuCard(
                          icon: Icons.send_rounded,
                          label: 'Share',
                          description: 'Share App Link',
                          color: Color(0xFF00C853),
                          route: '',
                          onTap: () => Share.share(
                            'Check out QR S&G App!\nhttps://github.com/YusufxAlbana/QR-code-Generator',
                            subject: 'QR S&G - QR Code Generator & Scanner',
                          ), 
                          delay: 600,
                        ),
                         _AnimatedMenuCard(
                          icon: Icons.history_edu_rounded,
                          label: 'History',
                          description: 'Your activity',
                          color: Color(0xFFFF9100),
                          route: '/history',
                          delay: 800,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(user.profileImagePath),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _AnimatedMenuCard extends StatefulWidget {
  const _AnimatedMenuCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.route,
    required this.delay,
    this.initialData,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final String route;
  final int delay;
  final String? initialData;
  final VoidCallback? onTap;

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

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

    // _scaleAnimation removed as it was unused and causing confusion/error


    // Staggered Start
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
        child: _PressableCard(
          route: widget.route,
          color: widget.color,
          initialData: widget.initialData,
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                  spreadRadius: -5,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: 32,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PressableCard extends StatefulWidget {
  final Widget child;
  final String route;
  final Color color;
  final String? initialData;
  final VoidCallback? onTap;

  const _PressableCard({
    required this.child,
    required this.route,
    required this.color,
    this.initialData,
    this.onTap,
  });

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  // Target scales
  static const double _kNormalScale = 1.0;
  static const double _kHoverScale = 1.05;
  static const double _kPressScale = 0.95;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    // Initialize directly to avoid LateInitializationError
    _scaleAnimation = Tween<double>(begin: _kNormalScale, end: _kNormalScale)
        .animate(_controller);
  }

  void _updateAnimation(double targetScale) {
    _scaleAnimation = Tween<double>(
      begin: _scaleAnimation.value,
      end: targetScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller
      ..reset()
      ..forward();
  }

  bool _isHovered = false;
  bool _isPressed = false;

  void _handleStateChange() {
    double target = _kNormalScale;
    if (_isPressed) {
      target = _kPressScale; // Press overrides hover
    } else if (_isHovered) {
      target = _kHoverScale;
    }
    
    // Create new animation to target
    _scaleAnimation = Tween<double>(
      begin: _scaleAnimation.value, // Start from current value
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _isHovered = true;
        _handleStateChange();
      },
      onExit: (_) {
        _isHovered = false;
        _handleStateChange();
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) {
          _isPressed = true;
          _handleStateChange();
        },
        onTapUp: (_) {
          _isPressed = false;
          _handleStateChange();
          if (widget.onTap != null) {
            widget.onTap!();
          } else if (widget.route.isNotEmpty) {
             Navigator.pushNamed(
               context, 
               widget.route,
               arguments: widget.initialData,
             );
          }
        },
        onTapCancel: () {
          _isPressed = false;
          _handleStateChange();
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _RGBBottomGlow extends StatefulWidget {
  const _RGBBottomGlow();

  @override
  State<_RGBBottomGlow> createState() => _RGBBottomGlowState();
}

class _RGBBottomGlowState extends State<_RGBBottomGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                HSVColor.fromAHSV(0.6, _controller.value * 360, 0.6, 1.0)
                    .toColor()
                    .withOpacity(0.4),
              ],
            ),
          ),
        );
      },
    );
  }
}
