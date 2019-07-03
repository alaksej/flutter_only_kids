# only_kids

A Flutter project for the Only Kids hairdressing salon.

## Getting Started

### Generating SHA certificate fingerprint
#### Android
* ```cd c:\Program Files (x86)\Java\jre1.8.0_201\bin```
* ```keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore```
* Enter keystore password: ```android```
* Copy the SHA1 and add it to https://console.firebase.google.com/project/only-kids/settings/general/android:com.example.only_kids


### Firestore security rules
* ```firebase deploy --only firestore:rules```