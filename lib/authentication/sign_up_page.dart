import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');

  String username = '';
  String phoneNumber = '';
  String password = '';
  String errorMessage = '';

  void signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response =
            await apiService.signUp(username, phoneNumber, password);
        print('Sign-up successful: ${response}');
        setState(() {
          errorMessage = '';
        });
      } catch (error) {
        print('error is: ${error}');
        setState(() {
          errorMessage = 'Sign-up failed. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onChanged: (value) {
                  username = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Утасны дугаар'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Утасны дугаараа оруулна уу';
                  }
                  return null;
                },
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Sign Up'),
              ),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
