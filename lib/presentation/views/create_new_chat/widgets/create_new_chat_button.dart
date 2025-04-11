import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_social_chat/presentation/blocs/chat/chat_management/chat_management_cubit.dart';
import 'package:flutter_social_chat/core/constants/colors.dart';
import 'package:flutter_social_chat/presentation/design_system/custom_text.dart';

class CreateNewChatButton extends StatelessWidget {
  const CreateNewChatButton({
    super.key,
    required this.isCreateNewChatPageForCreatingGroup,
  });

  final bool isCreateNewChatPageForCreatingGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(customIndigoColor),
          padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
        ),
        onPressed: () {
          context.read<ChatManagementCubit>().createNewChannel(
                isCreateNewChatPageForCreatingGroup: isCreateNewChatPageForCreatingGroup,
              );
        },
        child: CustomText(
          text: isCreateNewChatPageForCreatingGroup
              ? AppLocalizations.of(context)?.createNewGroupChat ?? ''
              : AppLocalizations.of(context)?.createNewOneToOneChat ?? '',
          fontSize: 16,
        ),
      ),
    );
  }
}
