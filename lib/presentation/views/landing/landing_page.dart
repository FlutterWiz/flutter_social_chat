import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/presentation/design_system/colors.dart';
import 'package:flutter_social_chat/core/constants/enums/router_enum.dart';
import 'package:flutter_social_chat/presentation/blocs/sms_verification/auth_cubit.dart';
import 'package:flutter_social_chat/presentation/blocs/sms_verification/auth_state.dart';
import 'package:flutter_social_chat/presentation/design_system/widgets/custom_progress_indicator.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // Note: we use addPostFrameCallback, because the information, that is coming from the firebase, may not
  // come immediately. If it comes, then we navigate the user. If it does not come, then
  // we skip the build part, and show circular progress indicator to the user when the data is not exist.
  // when it comes, we trigger the bloclistener, and navigate the user.
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          final bool isUserLoggedIn = context.read<AuthCubit>().state.isLoggedIn;
          final bool isOnboardingCompleted = context.read<AuthCubit>().state.authUser.isOnboardingCompleted;

          if (isUserLoggedIn && !isOnboardingCompleted) {
            context.go(RouterEnum.onboardingView.routeName);
          } else if (isUserLoggedIn && isOnboardingCompleted) {
            context.go(RouterEnum.channelsView.routeName);
          } else {
            context.go(RouterEnum.signInView.routeName);
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, c) =>
          p.isUserCheckedFromAuthService != c.isUserCheckedFromAuthService && c.isUserCheckedFromAuthService,
      listener: (context, state) {
        final bool isUserLoggedIn = state.isLoggedIn;
        final bool isOnboardingCompleted = state.authUser.isOnboardingCompleted;

        if (isUserLoggedIn && !isOnboardingCompleted) {
          context.go(RouterEnum.onboardingView.routeName);
        } else if (isUserLoggedIn && isOnboardingCompleted) {
          context.go(RouterEnum.channelsView.routeName);
          ;
        } else {
          context.go(RouterEnum.signInView.routeName);
        }
      },
      child: const Scaffold(body: Center(child: CustomProgressIndicator(progressIndicatorColor: black))),
    );
  }
}
