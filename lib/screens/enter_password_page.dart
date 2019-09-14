import 'package:flutter/material.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/validators.dart';

import '../main.dart';

class EnterPasswordPage extends StatefulWidget {
  const EnterPasswordPage({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false;
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final AuthService authService = getIt.get<AuthService>();

  @override
  void initState() {
    emailTextController.text = widget.email;
    super.initState();
  }

  @override
  void dispose() {
    emailTextController.dispose();
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
                'Welcome back!\n'
                'Log in to your Only Kids account',
                style: Theme.of(context).textTheme.headline,
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: _formKey,
              autovalidate: _autovalidate,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Your e-mail address',
                    ),
                    validator: validateEmail,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordTextController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Align(
              child: RaisedButton(
                child: Text('Log in'),
                onPressed: () => _onLogIn(),
              ),
            ),
            Align(
              child: MaterialButton(
                child: Text('Forgot password?'),
                onPressed: () => {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onLogIn() async {
    setState(() {
      _autovalidate = true;
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    print('logging in...');
  }
}
