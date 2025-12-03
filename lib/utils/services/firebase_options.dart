// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'FirebaseOptions are not supported for this platform.',
        );
    }
  }

  // 🌐 WEB CONFIG (correct from your .env)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAlsnCIiGkWOdVUBoN1JFcQ7ZA__kKmrM",
    appId: "1:172633973684:web:469615ad531ea45a1b48e1",
    messagingSenderId: "172633973684",
    projectId: "school-management-system-99a72",
    authDomain: "school-management-system-99a72.firebaseapp.com",
    storageBucket: "school-management-system-99a72.firebasestorage.app",
    measurementId: "G-E5V8ZVD9GC",
  );

  // 🤖 ANDROID CONFIG (correct using google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCNUwtBO-L4xWw1nWBFSGb4_1K_bi9H7qU",
    appId: "1:172633973684:android:49be825dde975ccf1b48e1",
    messagingSenderId: "172633973684",
    projectId: "school-management-system-99a72",
    storageBucket: "school-management-system-99a72.firebasestorage.app",
  );

  // 🍏 iOS CONFIG (YOU MUST REPLACE WITH REAL VALUES FROM plist)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "REPLACE_WITH_IOS_API_KEY",
    appId: "REPLACE_WITH_IOS_APP_ID",
    messagingSenderId: "172633973684",
    projectId: "school-management-system-99a72",
    storageBucket: "school-management-system-99a72.firebasestorage.app",
    iosBundleId: "com.sumit.sms", // set your real bundle id
  );
}
