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
    apiKey: 'AIzaSyCFxqtILXkfERzOctTX9X8S0zIYZ3fugIc',
    appId: '1:77966571572:web:38a249b8f3c19d0c52f261',
    messagingSenderId: '77966571572',
    projectId: 'amino-coffee',
    authDomain: 'amino-coffee.firebaseapp.com',
    storageBucket: 'amino-coffee.appspot.com',
    measurementId: 'G-HYDVR3Q2NV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDnbM4EAufb__Dl5GFaLta3pjxUq90Qkjo',
    appId: '1:77966571572:android:73e2ffcb2374d12352f261',
    messagingSenderId: '77966571572',
    projectId: 'amino-coffee',
    storageBucket: 'amino-coffee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCgVxmArj0hhz9awYp3jmhCJr8p5bYfNYc',
    appId: '1:77966571572:ios:eaa04a54d736237252f261',
    messagingSenderId: '77966571572',
    projectId: 'amino-coffee',
    storageBucket: 'amino-coffee.appspot.com',
    iosClientId: '77966571572-f9q5vuoqj7uflfgpj38h5enugbuafdua.apps.googleusercontent.com',
    iosBundleId: 'com.example.animo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCgVxmArj0hhz9awYp3jmhCJr8p5bYfNYc',
    appId: '1:77966571572:ios:eaa04a54d736237252f261',
    messagingSenderId: '77966571572',
    projectId: 'amino-coffee',
    storageBucket: 'amino-coffee.appspot.com',
    iosClientId: '77966571572-f9q5vuoqj7uflfgpj38h5enugbuafdua.apps.googleusercontent.com',
    iosBundleId: 'com.example.animo',
  );
}
