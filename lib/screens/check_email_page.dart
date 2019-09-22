import 'package:flutter/material.dart';

import '../localizations.dart';

class CheckEmailPage extends StatelessWidget {
  CheckEmailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                l10ns.checkEmailForResetInfo,
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              child: RaisedButton(
                child: Text(l10ns.ok),
                onPressed: () => _onOk(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onOk(BuildContext context) async {
    Navigator.pop(context);
  }
}
