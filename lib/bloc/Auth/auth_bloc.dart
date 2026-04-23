import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>((event, emit) async {
      emit(AuthLoading());

      if (_auth.currentUser != null) {
        String uid = _auth.currentUser!.uid;
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();
        final isRegistered = doc.data()?['isRegistered'] ?? false;

        if (isRegistered) {
          emit(AuthAuthenticated(uid));
        } else {
          emit(NewUserState(uid));
        }
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LogIn>((event, emit) {
      emit(AuthAuthenticated(event.userId));
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      await Firebase.initializeApp();
      try {
        // clears previous account
        await _googleSignIn.signOut();
        final GoogleSignInAccount? account = await _googleSignIn.signIn();

        if (account == null) {
          emit(AuthError("Sign in cancelled"));
          return;
        }

        final GoogleSignInAuthentication auth = await account.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final uid = userCredential.user?.uid;
        final ref = FirebaseFirestore.instance.collection('users').doc(uid);
        final doc = await ref.get();

        if (!doc.exists) {
          await ref.set({'isRegistered': false, 'id': uid});
        }
        final user = userCredential.user;

        if (user == null) {
          emit(AuthError("User is null"));
          return;
        }

        if (doc.data() == null || doc.data()!['isRegistered'] == false) {
          emit(NewUserState(user.uid));
        } else {
          emit(AuthAuthenticated(user.uid));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      await FirebaseAuth.instance.signOut();
      emit(AuthUnauthenticated());
    });
  }
}
