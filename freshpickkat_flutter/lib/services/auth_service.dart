// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';

// import '../main.dart'; // Access global 'client'

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Callbacks for the UI to handle state changes
//   Function(String verificationId)? onCodeSent;
//   Function(String error)? onVerificationFailed;
//   Function(String message)? onSuccess; // Server verification success

//   String? _verificationId;

//   // 1. Send OTP (Interacts with Firebase)
//   Future<void> sendOtp(String phoneNumber) async {
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // Auto-resolution (Android mostly)
//           await _signInAndVerifyWithServer(credential);
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           if (onVerificationFailed != null) {
//             onVerificationFailed!(e.message ?? 'Verification failed');
//           }
//           throw e; // Rethrow to let caller know if they await this
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           _verificationId = verificationId;
//           if (onCodeSent != null) {
//             onCodeSent!(verificationId);
//           }
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {
//           _verificationId = verificationId;
//         },
//       );
//     } catch (e) {
//       throw Exception("Failed to send OTP: \$e");
//     }
//   }

//   // 2. Verify OTP and authenticate with Server
//   Future<void> verifyOtp(String otp) async {
//     if (_verificationId == null) {
//       throw Exception("Verification ID is missing. Request OTP first.");
//     }

//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: otp,
//       );
//       await _signInAndVerifyWithServer(credential);
//     } catch (e) {
//       // Catch Firebase or Server errors and rethrow for UI
//       throw Exception("OTP Verification failed: \$e");
//     }
//   }

//   // Helper: Sign in with Firebase credential then verify with Serverpod
//   Future<void> _signInAndVerifyWithServer(
//     PhoneAuthCredential credential,
//   ) async {
//     try {
//       // A. Firebase Sign In
//       final UserCredential userCredential = await _auth.signInWithCredential(
//         credential,
//       );
//       final User? user = userCredential.user;

//       if (user == null) throw Exception("Firebase user is null");

//       final String? idToken = await user.getIdToken();
//       if (idToken == null) throw Exception("Failed to retrieve ID Token");

//       // B. Serverpod Verification
//       // Using global 'client' from main.dart
//       final String result = await client.auth.verifyPhoneLogin(idToken);

//       if (result.isNotEmpty) {
//         // Success
//         if (onSuccess != null) {
//           onSuccess!("Login successful!"); // Or pass key/user object
//         }
//         // Save session logic here if needed (SessionManager)
//       } else {
//         throw Exception("Server rejected the login.");
//       }
//     } catch (e) {
//       throw Exception("Server Authentication Failed: \$e");
//     }
//   }
// }
