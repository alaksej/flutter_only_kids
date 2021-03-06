import 'package:flutter/material.dart';
import 'package:only_kids/screens/create_account_page.dart';
import 'package:only_kids/screens/enter_password_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/validators.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';
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
  final LoadingService _loadingService = getIt.get<LoadingService>();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
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
                      l10ns.useAccountViaEmail,
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
                        hintText: l10ns.yourEmailAddress,
                      ),
                      validator: validateEmail,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    child: RaisedButton(
                      child: Text(l10ns.next),
                      onPressed: () => _onNext(context),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  _onNext(BuildContext context) async {
    setState(() {
      _autovalidate = true;
    });

    if (!_formKey.currentState.validate()) {
      return;
    }

    final String email = textController.text;
    final bool userExists = await authService.userExists(email);
    if (userExists) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EnterPasswordPage(email: email)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateAccountPage(email: email)));
    }
  }
}
