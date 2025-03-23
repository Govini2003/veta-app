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
        return windows;
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
    apiKey: 'AIzaSyBgdx-5nRYAiEjiIoKBn661UVamYgnhQwg',
    appId: '1:596091829422:web:87a3075a440f449fbb013f',
    messagingSenderId: '596091829422',
    projectId: 'veta-login',
    authDomain: 'veta-login.firebaseapp.com',
    storageBucket: 'veta-login.firebasestorage.app',
    measurementId: 'G-NWVETG4P5J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBIS9_8-adzMqp6-Dg2X4pPUo6gx1D2ScE',
    appId: '1:596091829422:android:bc17802fee4b1463bb013f',
    messagingSenderId: '596091829422',
    projectId: 'veta-login',
    storageBucket: 'veta-login.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCY-eSbYyuS19f9Vi3hDOoA5LGb77m7gNM',
    appId: '1:596091829422:ios:9014bdfdbb8243f4bb013f',
    messagingSenderId: '596091829422',
    projectId: 'veta-login',
    storageBucket: 'veta-login.firebasestorage.app',
    iosClientId: '596091829422-6f29ptuilhpjfevforf4je12aubte398.apps.googleusercontent.com',
    iosBundleId: 'com.example.loginSignup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCY-eSbYyuS19f9Vi3hDOoA5LGb77m7gNM',
    appId: '1:596091829422:ios:f1ff95a004ffc765bb013f',
    messagingSenderId: '596091829422',
    projectId: 'veta-login',
    storageBucket: 'veta-login.firebasestorage.app',
    iosClientId: '596091829422-h0j4lun130u7qv8tigj5aqsdlk9k5lkg.apps.googleusercontent.com',
    iosBundleId: 'com.example.authFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBgdx-5nRYAiEjiIoKBn661UVamYgnhQwg',
    appId: '1:596091829422:web:e67e04795638ec54bb013f',
    messagingSenderId: '596091829422',
    projectId: 'veta-login',
    authDomain: 'veta-login.firebaseapp.com',
    storageBucket: 'veta-login.firebasestorage.app',
    measurementId: 'G-S8SSLBJ96R',
  );

}