import 'package:flutter/material.dart';

class EnterEmailPage extends StatelessWidget {
  const EnterEmailPage({Key key}) : super(key: key);

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
                'Use the Only Kids account by entering your email address',
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.email),
                hintText: 'Your e-mail address',
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              child: RaisedButton(
                child: Text('Next'),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
