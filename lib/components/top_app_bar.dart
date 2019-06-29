import 'package:flutter/material.dart';
import 'package:only_kids/screens/home_page.dart';
import 'package:only_kids/screens/login_page.dart';
import 'package:only_kids/services/user_service.dart';
import 'package:provider/provider.dart';

class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  TopAppBar({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserService _userService = Provider.of<UserService>(context);

    return StreamBuilder<bool>(
        stream: _userService.isLoggedIn$,
        builder: (context, snapshot) {
          return AppBar(
            title: Text(this.title),
            actions: _buildActions(_userService, context),
          );
        });
  }

  List<Widget> _buildActions(UserService userService, BuildContext context) {
    final List<Widget> widgets = <Widget>[];

    if (userService.isLoggedIn) {
      final List<String> placeholderCharSources = <String>[
        userService.currentUser.displayName,
        userService.currentUser.email,
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
            await userService.signOut();
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
    } else {
      widgets.add(
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
        ),
      );
    }

    return widgets;
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}

enum _AppBarOverflowOptions {
  signout,
}
