import 'package:barcode1/verify/phone_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final PhoneAuthService _phoneAuthService = PhoneAuthService();

  String? _verificationId;
  FirebaseAuth auth = FirebaseAuth.instance;

  //ConfirmationResult confirmationResult = null as ConfirmationResult;

  _phone(String x) async{
    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(x, );

     UserCredential userCredential = await confirmationResult.confirm(x);


  }
  _otp(String x) async{
   

   

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String phoneNumber = '+91' + _phoneNumberController.text.trim() ;
               //ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(phoneNumber );
                String? errorMessage = await _phoneAuthService.signUpWithPhone(phoneNumber);

                if (errorMessage == null) {
                  // Save the verificationId for later use
                  // For example, you can store it in a state variable
                 

                  // Show OTP input field
                } else {
                  // Display an error message to the user
                  // You can use a Flutter Toast or a SnackBar for this
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                    ),
                  );
                }
              },
              child: Text('Request OTP'),
            ),
            //if (_verificationId != null)
              Column(
                children: [
                  SizedBox(height: 16.0),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'OTP'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      String otp = _otpController.text.trim();
                      //_otp(otp);
                      // UserCredential userCredential = await confirmationResult.confirm(x);
                      String? errorMessage = await _phoneAuthService.signInWithPhone(otp);

                      if (errorMessage == null) {
                        
                        // Sign-up or sign-in successful
                        // Navigate to the next screen or perform any other action
                      } else {
                        // Display an error message to the user
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                          ),
                        );
                      }
                    },
                    child: Text('Verify OTP'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
