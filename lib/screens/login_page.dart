import 'package:flutter/material.dart';
import 'package:only_kids/main.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/enter_email_page.dart';
import 'package:only_kids/screens/phone_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';

class LoginPage extends StatelessWidget {
  final AuthService authService = getIt.get<AuthService>();
  final LoadingService loadingService = getIt.get<LoadingService>();

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10ns.logIn),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return StreamBuilder<bool>(
      stream: loadingService.loading$,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data) {
          return Spinner();
        } else {
          return Center(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    l10ns.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline,
                  ),
                ),
                _buildButton(
                  icon: SvgPicture.asset(
                    'assets/icons8-google.svg',
                    height: 20.0,
                  ),
                  text: l10ns.continueWithGoogle,
                  action: () => _onContinueWithGoogle(context),
                ),
                SizedBox(height: 10),
                _buildButton(
                  icon: Icon(
                    Icons.mail,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  text: l10ns.continueWithEmail,
                  action: () => _onContinueWithEmail(context),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildButton({Widget icon, String text, Function action}) {
    return Align(
      child: SizedBox(
        width: 250,
        height: 50,
        child: RaisedButton.icon(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          icon: icon,
          label: Text(text),
          onPressed: action,
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    showSnackBar(
      context: context,
      text: l10ns.signInFailedCheckInternet,
    );
  }

  void _onContinueWithGoogle(BuildContext context) async {
    UserProfile userProfile;
    try {
      userProfile = await authService.googleSignIn();
      if (userProfile == null) {
        _showSignInError(context);
        return;
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

  void _onContinueWithEmail(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => EnterEmailPage()));
  }
}
