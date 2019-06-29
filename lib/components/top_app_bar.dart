import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/screens/login_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  TopAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = Provider.of<AuthService>(context);

    return StreamBuilder<FirebaseUser>(
        stream: _authService.user,
        builder: (context, snapshot) {
          return AppBar(
            title: Text(this.title),
            actions: snapshot.hasData
                ? _buildUserActions(context, _authService, snapshot.data)
                : _buildLogInActions(context),
          );
        });
  }

  List<Widget> _buildUserActions(
    BuildContext context,
    AuthService authService,
    FirebaseUser user,
  ) {
    final List<Widget> widgets = <Widget>[];

    final List<String> placeholderCharSources = <String>[
      user.displayName,
      user.email,
      '-',
    ];
    final String placeholderChar = placeholderCharSources
        .firstWhere((String str) => str != null && str.trimLeft().isNotEmpty)
        .trimLeft()[0]
        .toUpperCase();

    widgets.add(
      Container(
        height: 6,
        child: CircleAvatar(
          child: Text(placeholderChar),
        ),
      ),
    );

    widgets.add(
      PopupMenuButton<_AppBarOverflowOptions>(
        onSelected: (_AppBarOverflowOptions selection) async {
          await authService.signOut();
        },
        itemBuilder: (BuildContext context) {
          return <PopupMenuEntry<_AppBarOverflowOptions>>[
            PopupMenuItem<_AppBarOverflowOptions>(
              value: _AppBarOverflowOptions.signout,
              child: const Text('Log Out'),
            )
          ];
        },
      ),
    );

    return widgets;
  }

  List<Widget> _buildLogInActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.account_circle),
        tooltip: 'Log in',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ),
          );
        },
      )
    ];
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

enum _AppBarOverflowOptions {
  signout,
}
