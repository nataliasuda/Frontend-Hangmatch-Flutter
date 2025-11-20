import 'package:flutter/material.dart';
import 'package:hangmatch/screens/invite_friend.dart';
import 'package:hangmatch/services/session_service.dart';
import 'package:hangmatch/widgets/form_component.dart';
import 'package:hangmatch/widgets/gradient_button.dart';
import 'package:hangmatch/widgets/heading.dart';
import 'package:hangmatch/widgets/slider_location.dart';

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  double _selectedRadius = 5;
  final _form = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();
  final SessionService _sessionService = SessionService();
  bool _isCreating = false;

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  Future<void> _createDraftAndInvite() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState?.save();

    setState(() {
      _isCreating = true;
    });

    try {
      final session = await _sessionService.createDraftSession(
        name: _sessionNameController.text,
        locationRadius: _selectedRadius.toInt(),
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => InviteFriendScreen(
                  sessionId: session.id!,
                  sessionName: session.name,
                  locationRadius: session.locationRadius,
                ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating session: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Heading(text: 'Create session', fontSize: 25),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _form,
              child: FormComponent(
                text: 'Session name',
                controller: _sessionNameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a session name.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _sessionNameController.text = value!;
                },
              ),
            ),
            const SizedBox(height: 35),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.purple.shade300, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Invite friends after creating session',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You will be able to invite friends on the next screen',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            Text(
              'Distance [km]',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            SliderLocation(
              onChanged: (value) {
                setState(() {
                  _selectedRadius = value;
                });
              },
            ),

            const SizedBox(height: 80),

            GradientButton(
              width: 351,
              height: 63,
              text: _isCreating ? 'CREATING...' : 'CREATE SESSION',
              onPressed: _isCreating ? null : () => _createDraftAndInvite(),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'You will invite friends after session creation',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
