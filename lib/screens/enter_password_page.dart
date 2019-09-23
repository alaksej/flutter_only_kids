import 'package:flutter/material.dart';
import 'package:only_kids/screens/password_reset_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/utils/validators.dart';
import 'package:only_kids/widgets/password_text_form_field.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';
import '../main.dart';

class EnterPasswordPage extends StatefulWidget {
  const EnterPasswordPage({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _EnterPasswordPageState createState() => _EnterPasswordPageState();
}

class _EnterPasswordPageState extends State<EnterPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final AuthService authService = getIt.get<AuthService>();
  final LoadingService _loadingService = getIt.get<LoadingService>();
  String get email => emailTextController.text;

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
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: StreamBuilder<bool>(
          stream: _loadingService.loading$,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data) {
              return Spinner();
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      l10ns.welcomeBack,
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
                            hintText: l10ns.yourEmailAddress,
                          ),
                          validator: validateEmail,
                        ),
                        SizedBox(height: 20),
                        PasswordTextFormField(
                          passwordTextController: passwordTextController,
                          hintText: l10ns.password,
                          validator: (value) {
                            if (value.isEmpty) {
                              return l10ns.enterPassword;
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
                      child: Text(l10ns.logIn),
                      onPressed: () => _onLogIn(context),
                    ),
                  ),
                  Align(
                    child: MaterialButton(
                      child: Text(l10ns.forgotPassword),
                      onPressed: () => _onForgotPassword(context),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  _onLogIn(BuildContext context) async {
    setState(() {
      _autovalidate = true;
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    final String password = passwordTextController.text;
    final user = await authService.passwordSignIn(email, password);
    if (user == null) {
      showSnackBar(
        scaffoldState: _scaffoldKey.currentState,
        text: OnlyKidsLocalizations.of(context).badUsernameOrPassword,
      );
      return;
    }

    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  _onForgotPassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetPage(email: email)));
  }
}
