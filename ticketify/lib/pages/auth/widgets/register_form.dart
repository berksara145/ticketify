import 'package:flutter/material.dart';
import 'package:ticketify/pages/auth/widgets/auth_text_field.dart';

class RegisterForm extends StatelessWidget {
  RegisterForm({super.key});
  final TextEditingController controller = TextEditingController();
  final String label = "DENEME";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Placeholder(
              fallbackWidth: 100,
              fallbackHeight: 100,
              color: Colors.red), // Replace with Image
          const SizedBox(height: 30),
          DropdownButtonFormField(
            items: <String>['Admin', 'User', 'Guest']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {},
            decoration: const InputDecoration(
              labelText: 'Enter User Type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 20),
          AuthTextField(controller: controller, label: label),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
