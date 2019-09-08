import 'package:flutter/material.dart';
import 'package:only_kids/services/auth_service.dart';
import 'package:only_kids/utils/utils.dart';

import '../main.dart';

class PhonePage extends StatefulWidget {
  PhonePage({Key key, this.initialPhoneNumber}) : super(key: key);

  final String initialPhoneNumber;

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final TextEditingController textController = TextEditingController();

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
    final AuthService _authService = getIt.get<AuthService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Phone number'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please provide your phone number',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'In case there is any issue with your appointment '
                'we may contact you using this phone number:',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            TextFormField(
              controller: textController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.phone_android),
                hintText: 'e.g., +375 29 111 11 11',
              ),
            ),
            RaisedButton(
              child: Text('Close'),
              onPressed: () => _onClose(context, _authService),
            ),
          ],
        ),
      ),
    );
  }

  _onClose(BuildContext context, AuthService authService) async {
    try {
      await authService.updateCurrentUserPhone(textController.text);
    } catch (e) {
      showSnackBar(context, text: 'Failed to update phone number');
    }

    Navigator.pop(context);
  }
}
