import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Defines the style of haptic feedback to trigger on press.
enum BouncyHaptic {
  none,
  light,
  medium,
  heavy,
  selection,
}

/// A tactile widget that scales down slightly when pressed and springs back
/// upon release, giving buttons and cards a responsive, physical feel.
class BouncyPress extends StatefulWidget {
  const BouncyPress({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.shrinkScale = 0.96,
    this.dimOpacity = 1.0,
    this.pressDuration = const Duration(milliseconds: 100),
    this.releaseDuration = const Duration(milliseconds: 160),
    this.pressCurve = Curves.easeInOut,
    this.releaseCurve = Curves.easeOutCubic,
    this.haptic = BouncyHaptic.light,
    this.behavior = HitTestBehavior.opaque,
    this.enabled = true,
  })  : assert(shrinkScale > 0.0 && shrinkScale <= 1.0,
            'shrinkScale must be between 0.0 and 1.0'),
        assert(dimOpacity >= 0.0 && dimOpacity <= 1.0,
            'dimOpacity must be between 0.0 and 1.0');

  /// The child widget to wrap and animate.
  final Widget child;

  /// Called when the user taps on the widget.
  final VoidCallback? onTap;

  /// Called when the user long-presses on the widget.
  final VoidCallback? onLongPress;

  /// Called when the user double-taps on the widget.
  final VoidCallback? onDoubleTap;

  /// Scale target when pressed (default: 0.96).
  final double shrinkScale;

  /// Opacity when pressed (default: 1.0 - no dimming). Set to e.g. 0.85 for dimming.
  final double dimOpacity;

  /// Duration to compress when pressed.
  final Duration pressDuration;

  /// Duration to bounce back when released.
  final Duration releaseDuration;

  /// Animation curve while compressing.
  final Curve pressCurve;

  /// Animation curve while springing back.
  final Curve releaseCurve;

  /// Haptic feedback triggered on tap down.
  final BouncyHaptic haptic;

  /// Hit test behavior of the gesture detector.
  final HitTestBehavior behavior;

  /// Whether interactions and animations are enabled.
  final bool enabled;

  @override
  State<BouncyPress> createState() => _BouncyPressState();
}

class _BouncyPressState extends State<BouncyPress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _isPressed = false;

  bool get _hasCallback =>
      widget.enabled &&
      (widget.onTap != null ||
          widget.onLongPress != null ||
          widget.onDoubleTap != null);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.pressDuration,
      reverseDuration: widget.releaseDuration,
    );
    _buildAnimations(widget.pressCurve);
  }

  void _buildAnimations(Curve curve) {
    final curved = CurvedAnimation(parent: _controller, curve: curve);
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: widget.shrinkScale).animate(curved);
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: widget.dimOpacity).animate(curved);
  }

  @override
  void didUpdateWidget(BouncyPress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pressDuration != widget.pressDuration ||
        oldWidget.releaseDuration != widget.releaseDuration) {
      _controller.duration = widget.pressDuration;
      _controller.reverseDuration = widget.releaseDuration;
    }
    if (oldWidget.shrinkScale != widget.shrinkScale ||
        oldWidget.dimOpacity != widget.dimOpacity) {
      _buildAnimations(widget.pressCurve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _triggerHaptic() {
    switch (widget.haptic) {
      case BouncyHaptic.light:
        HapticFeedback.lightImpact();
      case BouncyHaptic.medium:
        HapticFeedback.mediumImpact();
      case BouncyHaptic.heavy:
        HapticFeedback.heavyImpact();
      case BouncyHaptic.selection:
        HapticFeedback.selectionClick();
      case BouncyHaptic.none:
        break;
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!_hasCallback) return;
    _isPressed = true;
    _triggerHaptic();
    _buildAnimations(widget.pressCurve);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!_isPressed) return;
    _isPressed = false;
    _buildAnimations(widget.releaseCurve);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!_isPressed) return;
    _isPressed = false;
    _buildAnimations(widget.releaseCurve);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCallback) {
      return widget.child;
    }

    Widget content = ScaleTransition(
      scale: _scaleAnimation,
      alignment: Alignment.center,
      child: widget.child,
    );

    if (widget.dimOpacity < 1.0) {
      content = FadeTransition(
        opacity: _opacityAnimation,
        child: content,
      );
    }

    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onDoubleTap: widget.onDoubleTap,
      child: content,
    );
  }
}

/// Convenience extension on [Widget] to apply [BouncyPress].
extension BouncyPressExtension on Widget {
  /// Wraps this widget in a [BouncyPress] spring interaction.
  Widget bouncy({
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    double shrinkScale = 0.96,
    double dimOpacity = 1.0,
    Duration pressDuration = const Duration(milliseconds: 100),
    Duration releaseDuration = const Duration(milliseconds: 160),
    Curve pressCurve = Curves.easeInOut,
    Curve releaseCurve = Curves.easeOutCubic,
    BouncyHaptic haptic = BouncyHaptic.light,
    HitTestBehavior behavior = HitTestBehavior.opaque,
    bool enabled = true,
  }) =>
      BouncyPress(
        onTap: onTap,
        onLongPress: onLongPress,
        onDoubleTap: onDoubleTap,
        shrinkScale: shrinkScale,
        dimOpacity: dimOpacity,
        pressDuration: pressDuration,
        releaseDuration: releaseDuration,
        pressCurve: pressCurve,
        releaseCurve: releaseCurve,
        haptic: haptic,
        behavior: behavior,
        enabled: enabled,
        child: this,
      );
}
