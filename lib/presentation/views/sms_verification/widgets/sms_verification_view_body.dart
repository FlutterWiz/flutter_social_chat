import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/presentation/blocs/sign_in/phone_number_sign_in_cubit.dart';
import 'package:flutter_social_chat/presentation/blocs/sign_in/phone_number_sign_in_state.dart';
import 'package:flutter_social_chat/presentation/design_system/colors.dart';
import 'package:flutter_social_chat/presentation/design_system/widgets/custom_progress_indicator.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/confirmation_info_text_with_icon.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/confirmation_text_with_icon.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/resend_code_button.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/verification_confirm_button.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/sms_verification_pin_field.dart';
import 'package:flutter_social_chat/presentation/views/sms_verification/widgets/wave_animation.dart';

class SmsVerificationViewBody extends StatelessWidget {
  const SmsVerificationViewBody({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberSignInCubit, PhoneNumberSignInState>(
      builder: (context, state) {
        return Stack(
          children: [
            const CustomWaveAnimation(),
            if (state.isInProgress)
              const CustomProgressIndicator(progressIndicatorColor: white)
            else
              Padding(
                padding: const EdgeInsets.only(top: 160),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const ConfirmationTextWithIcon(),
                      ConfirmationInfoTextWithIcon(phoneNumber: phoneNumber),
                      const SmsVerificationPinField(),
                      const ResendCodeButton(),
                      VerificationConfirmButton(state: state),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
