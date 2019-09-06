import 'package:flutter/material.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/screens/appointment_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final AuthService _authService = getIt.get<AuthService>();

    return StreamBuilder<bool>(
      stream: _authService.loading$,
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
                RaisedButton.icon(
                  icon: SvgPicture.asset(
                    'assets/icons8-google.svg',
                    height: 20.0,
                  ),
                  label: const Text('Continue with Google'),
                  onPressed: () async {
                    try {
                      await _authService.googleSignIn() ? _navigateBack(context) : _showSignInError(context);
                    } on Exception catch (error) {
                      print(error);
                      _showSignInError(context);
                    }
                  },
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.mail),
                  label: const Text('Continue with Email'),
                  onPressed: () {},
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void _showSignInError(BuildContext context) {
    final SnackBar snackBar = SnackBar(
      duration: Duration(seconds: 3),
      content: const Text('Could not sign in.\n'
          'Is the Google Services file missing?'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _navigateBack(BuildContext context) {
    Navigator.pop(context);
  }
}
