// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyCT5u7P7HcPMXZJ7NLt2bkzHnLtIn6n2rw',
    appId: '1:547249946061:web:824232b18cc76f8c1e5884',
    messagingSenderId: '547249946061',
    projectId: 'stock-8a210',
    authDomain: 'stock-8a210.firebaseapp.com',
    storageBucket: 'stock-8a210.appspot.com',
    measurementId: 'G-BSWS6CXSNQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAp7UFXCh1wlmeaYmAbEOPPuuPowBc1nVU',
    appId: '1:547249946061:android:86e349cd513768ff1e5884',
    messagingSenderId: '547249946061',
    projectId: 'stock-8a210',
    storageBucket: 'stock-8a210.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD7bsVUTqA4RDtIdA-vzdwRpbnShDvmnSc',
    appId: '1:547249946061:ios:1f8230cc9901c0971e5884',
    messagingSenderId: '547249946061',
    projectId: 'stock-8a210',
    storageBucket: 'stock-8a210.appspot.com',
    iosBundleId: 'com.example.barcode',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD7bsVUTqA4RDtIdA-vzdwRpbnShDvmnSc',
    appId: '1:547249946061:ios:1f8230cc9901c0971e5884',
    messagingSenderId: '547249946061',
    projectId: 'stock-8a210',
    storageBucket: 'stock-8a210.appspot.com',
    iosBundleId: 'com.example.barcode',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCT5u7P7HcPMXZJ7NLt2bkzHnLtIn6n2rw',
    appId: '1:547249946061:web:7851c46258d053e51e5884',
    messagingSenderId: '547249946061',
    projectId: 'stock-8a210',
    authDomain: 'stock-8a210.firebaseapp.com',
    storageBucket: 'stock-8a210.appspot.com',
    measurementId: 'G-FKN930LE3R',
  );

}