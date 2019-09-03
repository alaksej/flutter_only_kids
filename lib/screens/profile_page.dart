import 'package:flutter/material.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/avatar.dart';

import '../main.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key key, @required this.userProfile}) : super(key: key);

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = getIt.get<AuthService>();

    assert(userProfile != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Avatar(
                      avatarSize: 80.0,
                      userProfile: userProfile,
                    ),
                  ),
                  Text(
                    userProfile.displayName,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Text(userProfile.email),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () => _signOut(context, authService),
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  _signOut(BuildContext context, AuthService authService) async {
    bool confirmed = await showConfirmationDialog(
      context,
      'Log out',
      'Are you sure you want to log out?',
      'Yes',
      'No',
    );
    if (!confirmed) {
      return;
    }

    Navigator.pop(context);
    await authService.signOut();
  }
}
