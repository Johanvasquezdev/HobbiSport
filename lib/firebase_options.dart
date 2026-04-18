import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are only configured for web in this project. '
          'Use platform config files for mobile/desktop (google-services.json / GoogleService-Info.plist).',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError('Fuchsia is not supported.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC37X6z8REKSA_lm_KJjN41_8aRVcjS-u4',
    appId: '1:38348744062:web:5114f0d5422bbe373c3f2f',
    messagingSenderId: '38348744062',
    projectId: 'hobbysport-b994f',
    authDomain: 'hobbysport-b994f.firebaseapp.com',
    storageBucket: 'hobbysport-b994f.firebasestorage.app',
    measurementId: 'G-YQXJ6LHF0D',
  );
}
