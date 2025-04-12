import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/presentation/blocs/chat/chat_management/chat_management_cubit.dart';
import 'package:flutter_social_chat/presentation/blocs/chat/chat_management/chat_management_state.dart';
import 'package:flutter_social_chat/presentation/design_system/colors.dart';
import 'package:flutter_social_chat/presentation/design_system/widgets/custom_app_bar.dart';
import 'package:flutter_social_chat/presentation/design_system/widgets/custom_progress_indicator.dart';
import 'package:flutter_social_chat/presentation/views/create_new_chat/widgets/create_new_chat_button.dart';
import 'package:flutter_social_chat/presentation/views/create_new_chat/widgets/creating_group_chat_page_details.dart';
import 'package:flutter_social_chat/presentation/views/create_new_chat/widgets/user_list_view.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class CreateNewChatPage extends StatelessWidget {
  const CreateNewChatPage({
    super.key,
    required this.userListController,
    this.isCreateNewChatPageForCreatingGroup,
  });

  final StreamUserListController userListController;
  final bool? isCreateNewChatPageForCreatingGroup;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatManagementCubit, ChatManagementState>(
      listener: (context, state) {
        if (state.isChannelCreated) {
          context.read<ChatManagementCubit>().reset();
          context.go(context.namedLocation('channels_page'));
        }
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (context, result) {},
        child: Scaffold(
          appBar: CustomAppBar(
            isTitleCentered: false,
            leading: IconButton(
              onPressed: () {
                context.read<ChatManagementCubit>().reset();
                context.go(context.namedLocation('channels_page'));
              },
              icon: const Icon(CupertinoIcons.back, color: black),
            ),
          ),
          body: BlocBuilder<ChatManagementCubit, ChatManagementState>(
            builder: (context, state) {
              if (state.isInProgress) {
                return const CustomProgressIndicator(progressIndicatorColor: black);
              } else {
                return SingleChildScrollView(
                  child: RefreshIndicator(
                    onRefresh: () => userListController.refresh(),
                    child: Column(
                      children: [
                        UserListView(
                          userListController: userListController,
                          isCreateNewChatPageForCreatingGroup: isCreateNewChatPageForCreatingGroup,
                        ),
                        if (isCreateNewChatPageForCreatingGroup!)
                          CreatingGroupChatPageDetails(
                            isCreateNewChatPageForCreatingGroup: isCreateNewChatPageForCreatingGroup,
                          )
                        else
                          CreateNewChatButton(
                            isCreateNewChatPageForCreatingGroup: isCreateNewChatPageForCreatingGroup!,
                          ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
