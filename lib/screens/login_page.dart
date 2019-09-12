import 'package:flutter/material.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/phone_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/spinner.dart';

class LoginPage extends StatelessWidget {
  LoginPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final AuthService authService = getIt.get<AuthService>();

    return StreamBuilder<bool>(
      stream: authService.loading$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data) {
          return Spinner();
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(30),
                  child: const Text(
                    'Please, sign in using one of the methods below:',
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildButton(
                  icon: SvgPicture.asset(
                    'assets/icons8-google.svg',
                    height: 20.0,
                  ),
                  text: 'Continue with Google',
                  action: () => _onContinueWithGoogle(context, authService),
                ),
                SizedBox(height: 10),
                _buildButton(
                    icon: Icon(
                      Icons.mail,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    text: 'Continue with Email',
                    action: () {}),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton({Widget icon, String text, Function action}) {
    return SizedBox(
      width: 200,
      height: 50,
      child: RaisedButton.icon(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        icon: icon,
        label: Text(text),
        onPressed: action,
      ),
    );
  }

  void _showSignInError(BuildContext context) {
    showSnackBar(
      context,
      text: 'Could not sign in.\n'
          'Check your internet connection and try again',
    );
  }

  void _onContinueWithGoogle(
    BuildContext context,
    AuthService authService,
  ) async {
    UserProfile userProfile;
    try {
      userProfile = await authService.googleSignIn();
      if (userProfile == null) {
        _showSignInError(context);
      }
    } on Exception catch (error) {
      print(error);
      _showSignInError(context);
      return;
    }

    if (userProfile.phoneNumber == null || userProfile.phoneNumber.isEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => PhonePage(initialPhoneNumber: userProfile.phoneNumber)),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
