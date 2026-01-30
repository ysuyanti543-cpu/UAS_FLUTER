import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get web => const FirebaseOptions(
        apiKey: 'ISI_API_KEY',
        authDomain: 'ISI_AUTH_DOMAIN',
        projectId: 'ISI_PROJECT_ID',
        storageBucket: 'ISI_STORAGE_BUCKET',
        messagingSenderId: 'ISI_SENDER_ID',
        appId: 'ISI_APP_ID',
      );
}
