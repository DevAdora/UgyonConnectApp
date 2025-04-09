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
    apiKey: "AIzaSyBGN4w1CF_Qm1jFoUWPpwnE5dIMrYQQaRg",
    appId: "1:720266418647:web:24e3b576a5d71c158f1392",
    messagingSenderId: "720266418647",
    projectId: "ugyon-d1947",
    authDomain: "ugyon-d1947.firebaseapp.com",
    storageBucket: "ugyon-d1947.firebasestorage.app",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBGN4w1CF_Qm1jFoUWPpwnE5dIMrYQQaRg",
    appId: "1:720266418647:web:24e3b576a5d71c158f1392",
    messagingSenderId: "720266418647",
    projectId: "ugyon-d1947",
    authDomain: "ugyon-d1947.firebaseapp.com",
    storageBucket: "ugyon-d1947.firebasestorage.app",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBGN4w1CF_Qm1jFoUWPpwnE5dIMrYQQaRg",
    appId: "1:720266418647:web:24e3b576a5d71c158f1392",
    messagingSenderId: "720266418647",
    projectId: "ugyon-d1947",
    authDomain: "ugyon-d1947.firebaseapp.com",
    storageBucket: "ugyon-d1947.firebasestorage.app",
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: "AIzaSyBGN4w1CF_Qm1jFoUWPpwnE5dIMrYQQaRg",
    appId: "1:720266418647:web:24e3b576a5d71c158f1392",
    messagingSenderId: "720266418647",
    projectId: "ugyon-d1947",
    authDomain: "ugyon-d1947.firebaseapp.com",
    storageBucket: "ugyon-d1947.firebasestorage.app",
  );
}
