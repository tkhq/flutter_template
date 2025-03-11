import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../widgets/buttons.dart';
import '../providers/auth.dart';

class OTPScreen extends StatelessWidget {
  final String otpId;
  final String organizationId;

  const OTPScreen({
    super.key,
    required this.otpId,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    return Scaffold(
        body: Center(
            child: Container(
                height: 300,
                width: 350,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/logo.svg', height: 40),
                    SizedBox(height: 20),
                    Text(
                      'Enter OTP Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Pinput(
                      controller: otpController,
                      length: 6,
                      isCursorAnimationEnabled: false,
                      showCursor: false,
                      pinAnimationType: PinAnimationType.fade,
                      defaultPinTheme: PinTheme(
                          width: 45,
                          height: 60,
                          textStyle: TextStyle(fontSize: 24),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5))),
                      onCompleted: (value) => otpController.text = value,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              {
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(child: Consumer<AuthRelayerProvider>(
                            builder: (context, authRelayerProvider, child) {
                          return LoadingButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            onPressed: () async {
                              final otpCode = otpController.text;
                              if (otpCode.isNotEmpty) {
                                await authRelayerProvider.completeOtpAuth(
                                  otpId: otpId,
                                  otpCode: otpCode,
                                  organizationId: organizationId,
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Please enter the OTP code')),
                                );
                              }
                            },
                            isLoading: authRelayerProvider
                                .isLoading('completeOtpAuth'),
                            text: 'Continue',
                          );
                        })),
                      ],
                    ),
                  ],
                ))));
  }
}
