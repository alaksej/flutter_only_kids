import 'package:flutter/material.dart';
import 'package:only_kids/models/user_profile.dart';
import 'package:provider/provider.dart';

class PhonePage extends StatelessWidget {
  const PhonePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserProfile userProfile = Provider.of<UserProfile>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              keyboardType: TextInputType.phone,
              initialValue: userProfile.phoneNumber,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.phone_android),
                hintText: 'e.g., +375 29 111 11 11',
              ),
            ),
            RaisedButton(
              child: Text('Close'),
              onPressed: () => Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName)),
            ),
          ],
        ),
      ),
    );
  }
}
