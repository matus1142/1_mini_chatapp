import 'package:flutter/material.dart';
import 'package:mini_chatapp/services/auth/auth_service.dart';
import 'package:mini_chatapp/components/my_button.dart';
import 'package:mini_chatapp/components/my_textfield.dart';

class LoginPage extends StatelessWidget {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  LoginPage({super.key, this.onTap});

  void login(BuildContext context) async {
    // get auth service
    final _authService = AuthService();

    try {
      // try login
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      // catch any error
      // Do Not Use BuildContext in Async Gaps
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
              "Welcome back, you've been missed!",
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
              height: 25,
            ),
            // login button
            MyButton(
              text: 'Login',
              onTap: () => login(context),
            ),
            const SizedBox(
              height: 25,
            ),
            // register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
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
