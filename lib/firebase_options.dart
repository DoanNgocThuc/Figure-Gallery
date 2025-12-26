import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCHu42vFv70IjGz33IsvTD5QtnuugmIjAs',
    appId: '1:787156336212:web:3af857bf9e2956d9ed77c1',
    messagingSenderId: '787156336212',
    projectId: 'figure-gallery',
    authDomain: 'figure-gallery.firebaseapp.com',
    storageBucket: 'figure-gallery.firebasestorage.app',
    measurementId: 'G-KVBR3Y36HX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnyrFeIQZnI1QHmNHsjj3qscc9qETRdk4',
    appId: '1:787156336212:android:7bcd07230bf7bd2eed77c1',
    messagingSenderId: '787156336212',
    projectId: 'figure-gallery',
    storageBucket: 'figure-gallery.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAMYdIIeg0yXUJO-l61tXgpLSoTSh-QLHM',
    appId: '1:787156336212:ios:8e075e12d35ac9daed77c1',
    messagingSenderId: '787156336212',
    projectId: 'figure-gallery',
    storageBucket: 'figure-gallery.firebasestorage.app',
    iosBundleId: 'com.example.figureGallery',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAMYdIIeg0yXUJO-l61tXgpLSoTSh-QLHM',
    appId: '1:787156336212:ios:8e075e12d35ac9daed77c1',
    messagingSenderId: '787156336212',
    projectId: 'figure-gallery',
    storageBucket: 'figure-gallery.firebasestorage.app',
    iosBundleId: 'com.example.figureGallery',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCHu42vFv70IjGz33IsvTD5QtnuugmIjAs',
    appId: '1:787156336212:web:51683b9009338117ed77c1',
    messagingSenderId: '787156336212',
    projectId: 'figure-gallery',
    authDomain: 'figure-gallery.firebaseapp.com',
    storageBucket: 'figure-gallery.firebasestorage.app',
    measurementId: 'G-EEY03PBXKY',
  );
}
