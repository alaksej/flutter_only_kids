import 'package:flutter/material.dart';

class CheckEmailPage extends StatelessWidget {
  CheckEmailPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Text(
                'Check your email\n'
                'The information on how to reset your password has been sent',
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              child: RaisedButton(
                child: Text('Ok'),
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
