import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_social_chat/core/constants/colors.dart';
import 'package:flutter_social_chat/core/constants/enums/router_enum.dart';
import 'package:go_router/go_router.dart';

Widget bottomNavigationBuilder(BuildContext context) {
  return BottomNavigationBar(
    backgroundColor: white,
    currentIndex: _calculateSelectedIndex(context),
    selectedItemColor: customIndigoColor,
    onTap: (index) => _onItemTapped(index, context),
    items: [
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)?.chats,
        icon: const Icon(CupertinoIcons.chat_bubble_2, size: 31),
        activeIcon: const Icon(CupertinoIcons.chat_bubble_2_fill, size: 31),
      ),
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)?.camera,
        icon: const Icon(CupertinoIcons.camera, size: 30),
        activeIcon: const Icon(CupertinoIcons.camera_fill, size: 30),
      ),
      BottomNavigationBarItem(
        label: AppLocalizations.of(context)?.profile,
        icon: const Icon(FontAwesomeIcons.user, size: 29),
        activeIcon: const Icon(FontAwesomeIcons.userAlt, size: 29),
      ),
    ],
  );
}

int _calculateSelectedIndex(BuildContext context) {
  final String location = GoRouterState.of(context).uri.toString();

  if (location == RouterEnum.channelsView.routeName) {
    return 0;
  }
  if (location == RouterEnum.cameraView.routeName) {
    return 1;
  }
  if (location == RouterEnum.profileView.routeName) {
    return 2;
  }
  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      GoRouter.of(context).go(RouterEnum.channelsView.routeName);
      break;
    case 1:
      GoRouter.of(context).go(RouterEnum.cameraView.routeName);
      break;
    case 2:
      GoRouter.of(context).go(RouterEnum.profileView.routeName);
      break;
  }
}
