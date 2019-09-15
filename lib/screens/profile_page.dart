import 'package:flutter/material.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:only_kids/screens/phone_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/avatar.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../main.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = getIt.get<AuthService>();

    return StreamBuilder<UserProfile>(
        stream: authService.userProfile$,
        builder: (context, snapshot) {
          final userProfile = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
            ),
            body: userProfile == null
                ? Spinner()
                : Center(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                                userProfile.displayName ?? '',
                                style: Theme.of(context).textTheme.headline,
                              ),
                              Text(userProfile.email),
                              SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Icon(Icons.phone),
                                      title: Text(userProfile.phoneNumber ?? 'No phone number'),
                                      trailing: Icon(Icons.edit),
                                      onTap: () => _onPhoneEdit(context, userProfile.phoneNumber),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () => _signOut(context, authService),
                            child: Text('Sign out'),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  _onPhoneEdit(BuildContext context, String phoneNumber) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => PhonePage(initialPhoneNumber: phoneNumber)),
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
