import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/presentation/blocs/sign_in/phone_number_sign_in_cubit.dart';
import 'package:flutter_social_chat/presentation/blocs/sign_in/phone_number_sign_in_state.dart';
import 'package:flutter_social_chat/presentation/design_system/colors.dart';
import 'package:flutter_social_chat/presentation/views/sign_in/widgets/phone_number_input_card.dart';

class SignInViewBody extends StatelessWidget {
  const SignInViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocBuilder<PhoneNumberSignInCubit, PhoneNumberSignInState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: size.width,
              height: size.height / 2.4,
              decoration: const BoxDecoration(
                color: customIndigoColor,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(28), bottomLeft: Radius.circular(28)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_android, size: 52, color: white),
                  Icon(Icons.sms, size: 52, color: white),
                  Icon(Icons.more_horiz, size: 52, color: white),
                  Icon(Icons.check_box, size: 52, color: white),
                ],
              ),
            ),
            const PhoneNumberInputCard(),
          ],
        );
      },
    );
  }
}
