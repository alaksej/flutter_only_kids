# only_kids

A Flutter project for the Only Kids hairdressing salon.

## Getting Started

### Generating SHA certificate fingerprint
#### Debug
##### Android
* ```cd c:\"Program Files (x86)"\Java\jre1.8.0_201\bin```
* ```keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore```
* Enter keystore password: ```android```
* Copy the SHA1 and add it to https://console.firebase.google.com/project/only-kids/settings/general/android:by.onlykids.flutter_only_kids

#### Release
* ```C:\Program Files\Android\Android Studio\jre\bin>keytool -genkey -v -keystore c:/Users/<username>/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key```

### Firestore security rules
* ```firebase deploy --only firestore:rules```