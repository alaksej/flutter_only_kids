[![Codemagic build status](https://api.codemagic.io/apps/5d713c68166ac9000c357197/5d713c68166ac9000c357196/status_badge.svg)](https://codemagic.io/app/5d713c68166ac9000c357197)

# Only Kids (Flutter)

A Flutter project for the Only Kids hairdressing salon.

## Getting Started
* `flutter run` - run in dev mode
* `flutter run --profile`
* `flutter run --release`

## Deploying Firestore security rules
* `firebase deploy --only firestore:rules`


## Deploying Storage security rules
* `firebase deploy --only storage`

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
* [How to Load Firebase Config in CodeMagic with Environment Variables](https://medium.com/flutter-community/how-to-load-firebase-config-in-codemagic-with-environment-variables-e36e0378b7e6):
  1. Encode google-services.json to base64: `certutil -encode google-services.json google-services-base64.json`
  1. Add ANDROID_FIREBASE_JSON environment variable to the [codemagic](https://codemagic.io) workflow and paste the base64 encoded file contents as a value
  1. Add prebuild script:
```bash
#!/bin/sh
echo $ANDROID_FIREBASE_JSON | base64 --decode > $FCI_BUILD_DIR/android/app/google-services.json
```

  > **Fix: base64 command not found.** Clear the spaces between base64 and --decode(by using the backspace key until the 4 in base64 deletes — as this signals that all Unicode characters are deleted) then add the 4 and the space back in again
* [Publish To Google Play](https://docs.codemagic.io/publishing/publishing-to-google-play/)

## Cloud Functions
* `firebase deploy --only functions`