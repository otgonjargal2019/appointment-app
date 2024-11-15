import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../services/api_service.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final ApiService apiService = ApiService(baseUrl: 'http://10.0.2.2:3000');
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _signIn() async {
    try {
      final user = await apiService.signIn(
          phoneNumberController.text.trim(), passwordController.text);

      if (user != null) {
        print('User signed in: ${user?.username}');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use the obtained idToken and accessToken as needed
      print('Google googleUser---------------------- ${googleUser}');
      print('Google auth---------------------- ${googleAuth}');
      String? idToken = googleAuth.idToken;
      String? accessToken = googleAuth.accessToken;
      print('Google idToken---------------------- ${idToken}');
      print('Google accessToken---------------------- ${accessToken}');

      // Call your backend API to sign in the user
      // Example: await apiService.signInWithGoogle(idToken);
      // Handle the response as needed

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
      });
    }
  }

  void _signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print('Facebook token---------------------- ${accessToken}');
        //print('Access Token: ${accessToken.token}');

        final userData = await FacebookAuth.instance.getUserData();
        print('Facebook user Data----------------------- $userData');

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          errorMessage = 'Facebook login failed: ${result.message}';
        });
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
      });
    }
  }

  void _registerNow() {
    Navigator.pushReplacementNamed(context, '/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Нэвтрэх')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Утасны дугаар'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Нууц үг'),
              obscureText: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/forgot_password');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text('Нэвтрэх'),
              ),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: 8,
                  ),
                ),
                Text(
                  'Эсвэл',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signInWithGoogle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 243, 249, 250),
                        foregroundColor: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('Google'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signInWithFacebook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 243, 249, 250),
                        foregroundColor: Colors.black,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/facebook.png',
                            height: 24,
                          ),
                          SizedBox(width: 8),
                          Text('Facebook'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                GestureDetector(
                  onTap: _registerNow,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
