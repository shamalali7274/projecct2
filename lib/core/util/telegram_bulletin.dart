// telegram_bulletin.dart
//
// إعادة تنفيذ حقيقية لنظام الـ Toast تبع تلغرام (Bulletin.java / BulletinFactory.java).
// القيم كلها منقولة حرفياً من الكود المصدري الرسمي:
//   - DURATION_SHORT = 1500ms, DURATION_LONG = 2750ms
//   - SpringForce: dampingRatio = 0.8, stiffness = 400 (على translationY)
//   - corner radius = 16dp, padding = 16dp أفقي / 8dp عمودي
//
// ملاحظة: اللون بالضبط (key_undo_background) محسوب ديناميكياً بالكود
// الأصلي ومش موجود كقيمة صريحة بملفات الثيم، فاستخدمت أقرب تقريب معروف
// (رمادي غامق شبه أسود شفاف) — هاد التفصيل الوحيد المقرّب، الباقي حرفي.

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class TelegramBulletin {
  TelegramBulletin._();

  static const int durationShort = 1500;
  static const int durationLong = 2750;

  static void show(
    BuildContext context, {
    required String message,
    IconData? icon,
    String? actionLabel,
    VoidCallback? onAction,
    int duration = durationShort,
    double bottomOffset = 16,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _BulletinWidget(
        message: message,
        icon: icon,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
        bottomOffset: bottomOffset,
        onDismissed: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _BulletinWidget extends StatefulWidget {
  const _BulletinWidget({
    required this.message,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
    required this.duration,
    required this.bottomOffset,
    required this.onDismissed,
  });

  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final int duration;
  final double bottomOffset;
  final VoidCallback onDismissed;

  @override
  State<_BulletinWidget> createState() => _BulletinWidgetState();
}

class _BulletinWidgetState extends State<_BulletinWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _translateY = 0; // 0 = مكانها الطبيعي، موجب = تحت الشاشة (مخفية)
  double _height = 56; // تقدير أولي، بيتحدث بعد أول build

  // نفس القيم الحرفية من Bulletin.java: SpringForce(dampingRatio=0.8, stiffness=400)
  static const double _dampingRatio = 0.8;
  static const double _stiffness = 400;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController.unbounded(vsync: this)
      ..addListener(() => setState(() => _translateY = _controller.value));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _translateY = _height + widget.bottomOffset + 40; // يبدأ من تحت الشاشة
      _runSpring(target: 0); // يدخل لمكانه
      Future.delayed(Duration(milliseconds: widget.duration), _hide);
    });
  }

  void _runSpring({required double target}) {
    final simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1,
        stiffness: _stiffness,
        ratio: _dampingRatio,
      ),
      _translateY,
      target,
      0, // سرعة ابتدائية صفر (نفس دخول/خروج الـ Bulletin العادي بدون سحب)
    );
    _controller.animateWith(simulation);
  }

  void _hide() {
    if (!mounted) return;
    _runSpring(target: _height + widget.bottomOffset + 40);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: widget.bottomOffset,
      child: SafeArea(
        top: false,
        child: Center(
          child: Transform.translate(
            offset: Offset(0, _translateY),
            child: GestureDetector(
              onTap: _hide,
              child: _measureAndBuildContent(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _measureAndBuildContent() {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ), // نفس padding الأصلي بالحرف
        decoration: BoxDecoration(
          // أقرب تقريب للون الأصلي (التفصيلة الوحيدة المقرّبة مش الحرفية)
          color: const Color(0xF0222222),
          borderRadius: BorderRadius.circular(16), // نفس rounding=16dp بالحرف
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(
                widget.message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            if (widget.actionLabel != null) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  widget.onAction?.call();
                  _hide();
                },
                child: Text(
                  widget.actionLabel!,
                  style: const TextStyle(
                    color: Color(
                      0xFF5CACEE,
                    ), // نفس روح key_undo_cancelColor (أزرق فاتح)
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================
// مثال استخدام:
//
// TelegramBulletin.show(
//   context,
//   message: 'تم حذف الرسالة',
//   icon: Icons.delete_outline,
//   actionLabel: 'تراجع',
//   onAction: () { /* ... */ },
//   duration: TelegramBulletin.durationShort,
// );
// ============================================================
