import 'package:flutter/material.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/validators.dart';

import '../main.dart';

class EnterEmailPage extends StatefulWidget {
  const EnterEmailPage({Key key}) : super(key: key);

  @override
  _EnterEmailPageState createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  final TextEditingController textController = TextEditingController();
  final AuthService authService = getIt.get<AuthService>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

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
            Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: TextFormField(
                controller: textController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.email),
                  hintText: 'Your e-mail address',
                ),
                validator: validateEmail,
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              child: RaisedButton(
                child: Text('Next'),
                onPressed: () => _onNext(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onNext() async {
    setState(() {
      _autovalidate = true;
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    final String email = textController.text;
    final bool userExists = await authService.userExists(email);
    if (userExists) {
      print('open enter password page');
    } else {
      print('open create user page');
    }
  }
}
