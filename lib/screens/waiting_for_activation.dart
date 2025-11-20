import 'package:flutter/material.dart';
import 'package:hangmatch/models/session.dart';
import 'package:hangmatch/screens/searching_location.dart';
import 'package:hangmatch/services/session_service.dart';

class WaitingForActivationScreen extends StatefulWidget {
  final String sessionId;
  final String sessionName;
  final String hostName;

  const WaitingForActivationScreen({
    super.key,
    required this.sessionId,
    required this.sessionName,
    required this.hostName,
  });

  @override
  State<WaitingForActivationScreen> createState() =>
      _WaitingForActivationScreenState();
}

class _WaitingForActivationScreenState
    extends State<WaitingForActivationScreen> {
  final SessionService _sessionService = SessionService();
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  Future<void> _startPolling() async {
    while (_isChecking && mounted) {
      await _checkSessionStatus();
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<void> _checkSessionStatus() async {
  try {
    final sessions = await _sessionService.getMySessions(context);
    
  
    final currentSession = sessions.firstWhere(
      (session) => session.id == widget.sessionId,
      orElse: () => Session(
        id: '',
        name: '',
        locationRadius: 0,
        invitedUserIds: [],
        createdAt: DateTime.now(),
        status: 'draft',
      ),
    );

 
    if (currentSession.id!.isNotEmpty && currentSession.status == 'active') {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchingLocation(sessionId: widget.sessionId),
          ),
        );
      }
      return;
    }
    
   
    if (currentSession.id!.isEmpty) {
     
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session is no longer available'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context);
      }
      return;
    }
    
    
    print('Session status: ${currentSession.status} - still waiting...');
    
  } catch (e) {
    print('Error checking session status: $e');
    
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error checking session: $e'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

  @override
  void dispose() {
    _isChecking = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animowana ikona
            Icon(Icons.hourglass_top, color: Colors.purple.shade300, size: 80),
            const SizedBox(height: 30),

            Text(
              'Waiting for host to activate',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              'Session: ${widget.sessionName}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Host: ${widget.hostName}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(color: Colors.purple),

            const SizedBox(height: 20),

            Text(
              'You will be redirected automatically when the session starts',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
