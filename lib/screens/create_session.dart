import 'package:flutter/material.dart';
import 'package:hangmatch/widgets/form_component.dart';
import 'package:hangmatch/widgets/gradient_button.dart';
import 'package:hangmatch/widgets/heading.dart';

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
            child: Form(
              key: _form,
            
              child: FormComponent(
                text: 'Session name',
              
                controller: _sessionNameController,
              
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter session name.';
                  }
              
                  return null;
                },
                onSaved: (value) {
                  _sessionNameController.text = value!;
                },
              ),
            ),
          ),
          GradientButton(
            width: 351,
            height: 63,
            text: 'START SESSION',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

