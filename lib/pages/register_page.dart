import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({super.key, this.onTap});
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void register(BuildContext context) async {
    final _authService = AuthService();

    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await _authService.signUpWithEmailPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                e.toString(),
              ),
            ),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Passwords don't match!",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(
              height: 50,
            ),
            // welcome back message
            Text(
              "Let's create an account for you",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            // email text field
            MyTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            const SizedBox(
              height: 10,
            ),
            // pw text field
            MyTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            // confirm pw text field
            MyTextField(
              hintText: 'Confirm password',
              obscureText: true,
              controller: _confirmPasswordController,
            ),
            const SizedBox(
              height: 25,
            ),
            // login button
            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(
              height: 25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
