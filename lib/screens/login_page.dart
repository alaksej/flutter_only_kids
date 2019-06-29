import 'package:flutter/material.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/screens/appointment_page.dart';
import 'package:only_kids/services/auth_service.dart';

import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final bool goToAppointmentAfterLogin;

  LoginPage({this.goToAppointmentAfterLogin = false});

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
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // SvgPicture.asset(
              //   'assets/lockup_photos_horizontal.svg',
              // ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: const Text(
                    'Log in to book an appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, color: Color(0x99000000)),
                  ),
                ),
              ),
              RaisedButton(
                padding: const EdgeInsets.all(15),
                child: const Text('Sign In with Google'),
                onPressed: () async {
                  try {
                    await _authService.googleSignIn()
                        ? goToAppointmentAfterLogin ? await _openAppointment(context) : _navigateBack(context)
                        : _showSignInError(context);
                  } on Exception catch (error) {
                    print(error);
                    _showSignInError(context);
                  }
                },
              ),
            ],
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

  Future<void> _openAppointment(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => AppointmentPage(),
      ),
    );
  }
}
