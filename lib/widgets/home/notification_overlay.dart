import 'package:flutter/material.dart';
import 'notification_card.dart';

class NotificationOverlayController {
  bool _isVisible = false;
  bool get isVisible => _isVisible;

  VoidCallback? _onToggle;

  void setToggleCallback(VoidCallback onToggle) {
    _onToggle = onToggle;
  }

  void toggle() {
    _isVisible = !_isVisible;
    _onToggle?.call();
  }

  void hide() {
    _isVisible = false;
    _onToggle?.call();
  }

  void dispose() {
    _onToggle = null;
  }
}

class NotificationOverlay extends StatefulWidget {
  final NotificationOverlayController controller;

  const NotificationOverlay({super.key, required this.controller});

  @override
  State<NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<NotificationOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    widget.controller.setToggleCallback(_handleToggle);
  }

  void _handleToggle() {
    if (widget.controller.isVisible) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: widget.controller.hide,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const Text(
                              'Notifications',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: widget.controller.hide,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Flexible(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              NotificationCard(
                                title: "You've been invited to the session!",
                                from: "From: Zuzia  • Session: Holiday",
                                primaryText: "Join",
                                secondaryText: "Reject",
                              ),
                              const SizedBox(height: 15),
                              NotificationCard(
                                title: "You've been invited to the session!",
                                from: "From: Zuzia  • Session: Holiday",
                                primaryText: "Join",
                                secondaryText: "Reject",
                              ),
                              const SizedBox(height: 15),
                              NotificationCard(
                                title: "You've been invited to the session!",
                                from: "From: Zuzia  • Session: Holiday",
                                primaryText: "Join",
                                secondaryText: "Reject",
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }
}
