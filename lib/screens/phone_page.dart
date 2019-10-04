import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/services/loading_service.dart';
import 'package:only_kids/utils/utils.dart';
import 'package:only_kids/widgets/overlay.dart';
import 'package:only_kids/widgets/spinner.dart';

import '../localizations.dart';
import '../main.dart';

class PhonePage extends StatefulWidget {
  PhonePage({Key key, this.initialPhoneNumber}) : super(key: key);

  final String initialPhoneNumber;

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final TextEditingController textController = TextEditingController();
  final LoadingService loadingService = getIt.get<LoadingService>();
  final AuthService authService = getIt.get<AuthService>();

  @override
  void initState() {
    super.initState();
    textController.text = widget.initialPhoneNumber;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10ns.phoneNumber),
      ),
      body: StreamBuilder<bool>(
          stream: loadingService.loading$,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data) {
              return Spinner();
            }

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      l10ns.providePhone,
                      style: Theme.of(context).textTheme.headline,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      l10ns.whyProvidePhone,
                      style: Theme.of(context).textTheme.subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextFormField(
                    controller: textController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.phone),
                      hintText: l10ns.phoneExample,
                    ),
                  ),
                  RaisedButton(
                    child: Text(l10ns.next),
                    onPressed: () => _onClose(context),
                  ),
                ],
              ),
            );
          }),
    );
  }

  _onClose(BuildContext context) async {
    final OnlyKidsLocalizations l10ns = OnlyKidsLocalizations.of(context);
    try {
      await authService.updateCurrentUserPhone(textController.text);
    } catch (e) {
      showSnackBar(context: context, text: l10ns.failedToUpdatePhone);
    }

    Navigator.pop(context);
    showToast(l10ns.changesSaved);
  }
}
