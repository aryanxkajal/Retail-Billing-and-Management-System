import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId; // Store the verification ID

  Future<String?> signUpWithPhone(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw e.message as Object;
        },
        codeSent: (String verificationId, int? resendToken) {
          // Save the verificationId for later use
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout, handle if needed
        },
      );
      return null; // Verification code sent successfully
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<String?> signInWithPhone(String smsCode) async {
    try {
      if (_verificationId == null) {
        throw 'Verification ID is null';
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(credential);
      return null; // Sign-in successful, no error message
    } catch (e) {
      return e.toString(); // Return error message
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
