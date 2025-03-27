// firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyCAGmw-D0ZPUkJajzooumqu0aMl1cAt6_0",
      authDomain: "ugyonconnectapp.firebaseapp.com",
      databaseURL:
          "https://ugyonconnectapp-default-rtdb.asia-southeast1.firebasedatabase.app",
      projectId: "ugyonconnectapp",
      storageBucket: "ugyonconnectapp.firebasestorage.app",
      messagingSenderId: "206650662788",
      appId: "1:206650662788:web:f7c11d87269db0190c07d1",
      measurementId: "G-C3MRFR8FYR",
    );
  }
}
