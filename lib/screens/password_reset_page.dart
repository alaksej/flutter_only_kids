import 'package:flutter/material.dart';
import 'package:only_kids/screens/check_email_page.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/utils/validators.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';
import '../main.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailTextController = TextEditingController();
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
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: StreamBuilder<bool>(
          stream: _loadingService.loading$,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!) {
              return Spinner();
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      l10ns.passwordReset,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: TextFormField(
                      controller: emailTextController,
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
                    child: ElevatedButton(
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
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context)!;
    try {
      await authService.sendPasswordResetEmail(email);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CheckEmailPage()));
    } catch (e) {
      showSnackBar(scaffoldState: _scaffoldKey.currentState, text: l10ns.errorResettingPassword);
    }
  }
}
