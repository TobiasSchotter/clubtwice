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
    apiKey: 'AIzaSyBMDJRi6EcPMruCE-K5lc-fpkHJcNDmGo8',
    appId: '1:921850895963:web:67480425f87daf1c76a97e',
    messagingSenderId: '921850895963',
    projectId: 'clubtwice-d9fa6',
    authDomain: 'clubtwice-d9fa6.firebaseapp.com',
    storageBucket: 'clubtwice-d9fa6.appspot.com',
    measurementId: 'G-SPSZRQFE51',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC1B1UpIFTTvlk6uTiKNjMtq-t7EUUOGqY',
    appId: '1:921850895963:android:46e21c5f6f1896b976a97e',
    messagingSenderId: '921850895963',
    projectId: 'clubtwice-d9fa6',
    storageBucket: 'clubtwice-d9fa6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCwZxlk59AfTqUEn1BzWVJ899zGSBmQdKE',
    appId: '1:921850895963:ios:ff61fb3aa60935c676a97e',
    messagingSenderId: '921850895963',
    projectId: 'clubtwice-d9fa6',
    storageBucket: 'clubtwice-d9fa6.appspot.com',
    iosClientId: '921850895963-r4cfsp2btbtki66os00pqi069hcmndd4.apps.googleusercontent.com',
    iosBundleId: 'com.clubtwice',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCwZxlk59AfTqUEn1BzWVJ899zGSBmQdKE',
    appId: '1:921850895963:ios:ff61fb3aa60935c676a97e',
    messagingSenderId: '921850895963',
    projectId: 'clubtwice-d9fa6',
    storageBucket: 'clubtwice-d9fa6.appspot.com',
    iosClientId: '921850895963-r4cfsp2btbtki66os00pqi069hcmndd4.apps.googleusercontent.com',
    iosBundleId: 'com.clubtwice',
  );
}
