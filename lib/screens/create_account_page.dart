import 'package:flutter/material.dart';
import 'package:only_kids/screens/phone_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/constants.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/utils/validators.dart';
import 'package:only_kids/widgets/password_text_form_field.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';
import '../main.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key key, this.email}) : super(key: key);

  final String email;

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _autovalidate = false;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final AuthService authService = getIt.get<AuthService>();
  final LoadingService _loadingService = getIt.get<LoadingService>();

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
                      l10ns.createNewAccount,
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
                          controller: nameTextController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: l10ns.fullName,
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return l10ns.enterYourName;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
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

                            if (value.length < minPasswordLength) {
                              return l10ns.passwordLengthValidation
                                  .replaceFirst(r'$minPasswordLength', minPasswordLength.toString());
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
                      child: Text(l10ns.create),
                      onPressed: () => _onCreate(context),
                    ),
                  ),
                  Align(
                    child: MaterialButton(
                      child: Text(l10ns.forgotPassword),
                      onPressed: () => {},
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  _onCreate(BuildContext context) async {
    setState(() {
      _autovalidate = true;
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    final String name = nameTextController.text;
    final String email = emailTextController.text;
    final String password = passwordTextController.text;
    final user = await authService.createUserWithPassword(email, password, name);

    if (user == null) {
      showSnackBar(
          scaffoldState: _scaffoldKey.currentState, text: OnlyKidsLocalizations.of(context).failedToCreateUser);
      return;
    }

    Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => PhonePage()),
    );
  }
}
