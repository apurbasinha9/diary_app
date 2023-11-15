import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/view/diary_view.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<void> createUserDocument(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if the user document already exists
    final userDoc = await userRef.get();
    if (!userDoc.exists) {
      await userRef.set({
        'email': user.email,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId:
                    "302605183636-dpspg66tgq1jcrf93udh0p69li2pscr8.apps.googleusercontent.com",
              ),
            ],
          );
        } else {
          final user = snapshot.data;
          if (user != null) {
            createUserDocument(user); // Create user document in Firestore
          }
          return const HomePage();
        }
      },
    );
  }
}
