import 'package:flutter/material.dart';
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
  final _form = GlobalKey<FormState>();
  final _sessionNameController = TextEditingController();

  @override
  void dispose() {
    _sessionNameController.dispose();

    super.dispose();
  }

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }
    _form.currentState?.save();
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
            SizedBox(height: 35),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFFD593F7,
                ).withAlpha((0.75 * 255).toInt()),
              ),
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Invite friends',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),
            Text(
              'Distance [km]',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            SliderLocation(),
            const SizedBox(height: 80),
            GradientButton(
              width: 351,
              height: 63,
              text: 'START SESSION',
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
