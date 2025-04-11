import 'package:flutter/material.dart';
import 'package:flutter_social_chat/presentation/design_system/custom_text.dart';
import 'package:flutter_social_chat/core/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.leading,
    this.isTitleCentered = true,
    this.titleColor = black,
    this.titleFontSize = 20,
    this.titleFontWeight = FontWeight.w500,
  }) : preferredSize = const Size.fromHeight(70.0);

  @override
  final Size preferredSize;
  final bool? isTitleCentered;
  final String? title;
  final Color? backgroundColor;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final appBarTitle = CustomText(
      color: titleColor ?? black,
      fontSize: titleFontSize ?? 20,
      text: title!,
      fontWeight: titleFontWeight ?? FontWeight.w500,
    );

    return AppBar(
      centerTitle: isTitleCentered,
      backgroundColor: backgroundColor ?? scaffoldBackgroundColor,
      toolbarHeight: 80,
      elevation: 0,
      leadingWidth: 90,
      leading: leading,
      surfaceTintColor: backgroundColor,
      shadowColor: transparent,
      title: title != null ? appBarTitle : null,
    );
  }
}
