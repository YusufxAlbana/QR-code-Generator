import 'package:flutter/material.dart';

/// A wrapper widget that adds hover/tap animations to any card or container.
/// Features:
/// - Scale animation on hover (web) and tap
/// - Optional elevation change
/// - Smooth spring-like animation curve
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double pressedScale;
  final Duration duration;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.02,
    this.pressedScale = 0.97,
    this.duration = const Duration(milliseconds: 150),
    this.decoration,
    this.padding,
    this.margin,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  
  double get _scale {
    if (_isPressed) return widget.pressedScale;
    if (_isHovered) return widget.hoverScale;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(_scale),
          transformAlignment: Alignment.center,
          padding: widget.padding,
          margin: widget.margin,
          decoration: widget.decoration?.copyWith(
            boxShadow: _isHovered && widget.decoration?.boxShadow != null
                ? widget.decoration!.boxShadow!.map((shadow) => BoxShadow(
                    color: shadow.color.withOpacity(shadow.color.opacity * 1.5),
                    blurRadius: shadow.blurRadius * 1.3,
                    spreadRadius: shadow.spreadRadius + 2,
                    offset: Offset(shadow.offset.dx, shadow.offset.dy + 2),
                  )).toList()
                : widget.decoration?.boxShadow,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A simpler version that just wraps existing containers with hover animation
class HoverAnimationWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double hoverScale;
  final double pressedScale;
  final Duration duration;

  const HoverAnimationWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.hoverScale = 1.02,
    this.pressedScale = 0.97,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  State<HoverAnimationWrapper> createState() => _HoverAnimationWrapperState();
}

class _HoverAnimationWrapperState extends State<HoverAnimationWrapper> {
  bool _isHovered = false;
  bool _isPressed = false;

  double get _scale {
    if (_isPressed) return widget.pressedScale;
    if (_isHovered) return widget.hoverScale;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onTap != null ? (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        } : null,
        onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
        child: AnimatedScale(
          scale: _scale,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeOutCubic,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
