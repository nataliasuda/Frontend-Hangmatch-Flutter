import 'package:flutter/material.dart';
import 'package:hangmatch/screens/waiting_for_activation.dart';
import 'package:hangmatch/services/session_service.dart';
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
  final SessionService _sessionService = SessionService();
  List<dynamic> _invitations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    widget.controller.setToggleCallback(_handleToggle);
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    try {
      final invitations = await _sessionService.getMyInvitations(context);
      setState(() {
        _invitations = invitations;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading invitations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleJoinSession(
    String sessionId,
    String sessionName,
    String hostName,
  ) async {
    try {
      await _sessionService.joinSession(context, sessionId);

      widget.controller.hide();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => WaitingForActivationScreen(
                  sessionId: sessionId,
                  sessionName: sessionName,
                  hostName: hostName,
                ),
          ),
        );
      }

      await _loadInvitations();
    } catch (e) {
      print('Error joining session: $e');
    }
  }

  Future<void> _handleRejectSession(String sessionId) async {
    try {
      await _sessionService.rejectSession(context, sessionId);

      await _loadInvitations();
    } catch (e) {
      print('Error rejecting session: $e');
    }
  }

  void _handleToggle() {
    if (widget.controller.isVisible) {
      _showOverlay();

      _loadInvitations();
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

                              if (_isLoading)
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (_invitations.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(
                                    'No invitations',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              else
                                ..._invitations.map((invitation) {
                                  return Column(
                                    children: [
                                      NotificationCard(
                                        title:
                                            "You've been invited to the session!",
                                        from:
                                            "From: ${invitation['invited_by']} • Session: ${invitation['session_name']}",
                                        primaryText: "Join",
                                        secondaryText: "Reject",
                                        onPrimaryPressed:
                                            () => _handleJoinSession(
                                              invitation['session_id'],
                                              invitation['session_name'],
                                              invitation['invited_by'],
                                            ),
                                        onSecondaryPressed:
                                            () => _handleRejectSession(
                                              invitation['session_id'],
                                            ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  );
                                }).toList(),

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
