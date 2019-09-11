# Only Kids (Flutter)

A Flutter project for the Only Kids hairdressing salon.

## Getting Started
* `flutter run` - run in dev mode
* `flutter run --profile`
* `flutter run --release`

## Deploying Firestore security rules
* `firebase deploy --only firestore:rules`

## Signing and building the app for Android
### Generating SHA certificate fingerprint
Make keytool available in the path: `C:\"Program Files"\Android\"Android Studio"\jre\bin\`
#### Debug Key
* `cd c:\"Program Files (x86)"\Java\jre1.8.0_201\bin`
* `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore`
* Enter keystore password: `android`
* Copy the SHA1 and add it to [Firebase project settings](https://console.firebase.google.com/project/only-kids/settings/general/android:by.onlykids.flutter_only_kids)

#### Release Key
* Generate the release key:
 `keytool -genkey -v -keystore c:/Users/<username>/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`
* Obtain the release key from keystore: 
 `keytool -exportcert -list -v -alias <your-key-name> -keystore %USERPROFILE%\key.jks`
* Copy the release SHA1 and add it to [Firebase project settings](https://console.firebase.google.com/project/only-kids/settings/general/android:by.onlykids.flutter_only_kids)

#### Published app
* Obtain the key from [Google Play console](https://play.google.com/apps/publish/?account=7861977898292030768#KeyManagementPlace:p=by.onlykids.flutter_only_kids&appid=4975181278845871034)
* Copy the key to [Firebase project settings](https://console.firebase.google.com/project/only-kids/settings/general/android:by.onlykids.flutter_only_kids)


### Building Android AppBundle
* `flutter build appbundle` - build Android app bundle

## Configuring multiple environments
* [Configure multiple firebase projects](https://firebase.google.com/docs/projects/multiprojects#top_of_page)

## CI/CD
* [How to Load Firebase Config in CodeMagic with Environment Variables](https://medium.com/flutter-community/how-to-load-firebase-config-in-codemagic-with-environment-variables-e36e0378b7e6)
