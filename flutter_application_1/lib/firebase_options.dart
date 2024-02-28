// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKRM6V1h1xH9HyKguXl2vXDnLkWjS8P7w',
    appId: '1:522123676200:web:21dfb0732ec892d809831d',
    messagingSenderId: '522123676200',
    projectId: 'mob-dev-85db5',
    authDomain: 'mob-dev-85db5.firebaseapp.com',
    storageBucket: 'mob-dev-85db5.appspot.com',
    measurementId: 'G-RTCPFPMTD7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKiOFkEU2unand8fo0BODPOJgNsyBx-C8',
    appId: '1:522123676200:android:62986184c00c17e209831d',
    messagingSenderId: '522123676200',
    projectId: 'mob-dev-85db5',
    storageBucket: 'mob-dev-85db5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCo9gL-hjoLQPxRDtfWkG98RiGZ47sOaCQ',
    appId: '1:522123676200:ios:1674993a971c089b09831d',
    messagingSenderId: '522123676200',
    projectId: 'mob-dev-85db5',
    storageBucket: 'mob-dev-85db5.appspot.com',
    iosClientId: '522123676200-63fq7fe9cd01adg5vqqc0pev860t0cbq.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCo9gL-hjoLQPxRDtfWkG98RiGZ47sOaCQ',
    appId: '1:522123676200:ios:037adfda04ec22b709831d',
    messagingSenderId: '522123676200',
    projectId: 'mob-dev-85db5',
    storageBucket: 'mob-dev-85db5.appspot.com',
    iosClientId: '522123676200-3ij97gjnq6746avabdh2gkm8k6cduvvf.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplication1.RunnerTests',
  );
}
