import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_social_chat/presentation/blocs/sms_verification/auth_cubit.dart';
import 'package:flutter_social_chat/presentation/blocs/chat/chat_management/chat_management_state.dart';
import 'package:flutter_social_chat/core/interfaces/i_getstream_chat_repository.dart';
import 'package:flutter_social_chat/data/extensions/auth/database_extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatManagementCubit extends Cubit<ChatManagementState> {
  final String randomGroupProfilePhoto = 'https://picsum.photos/200/300';

  final IGetstreamChatRepository _chatService;
  final FirebaseFirestore _firebaseFirestore;
  final AuthCubit _authCubit;

  late StreamSubscription<List<Channel>>? _currentUserChannelsSubscription;

  ChatManagementCubit(this._chatService, this._firebaseFirestore, this._authCubit)
      : super(ChatManagementState.empty()) {
    _currentUserChannelsSubscription =
        _chatService.channelsThatTheUserIsIncluded.listen(_listenCurrentUserChannelsChangeStream);
  }

  @override
  Future<void> close() async {
    await _currentUserChannelsSubscription?.cancel();
    super.close();
  }

  void reset() {
    emit(
      state.copyWith(
        isInProgress: false,
        isChannelCreated: false,
        isCapturedPhotoSent: false,
        listOfSelectedUsers: {},
        listOfSelectedUserIDs: {},
        channelName: '',
      ),
    );
  }

  void channelNameChanged({required String channelName}) {
    emit(state.copyWith(channelName: channelName));
  }

  void validateChannelName({required bool isChannelNameValid}) {
    emit(
      state.copyWith(isChannelNameValid: isChannelNameValid),
    );
  }

  Future<void> _listenCurrentUserChannelsChangeStream(List<Channel> currentUserChannels) async {
    emit(state.copyWith(currentUserChannels: currentUserChannels));
  }

  Future<void> sendCapturedPhotoToSelectedUsers({
    required String pathOfTheTakenPhoto,
    required int sizeOfTheTakenPhoto,
  }) async {
    if (state.isInProgress) {
      return;
    }

    emit(state.copyWith(isInProgress: true));

    final channelId = state.currentUserChannels[state.userIndex].id;

    // To show the progress indicator, and well UX.
    await Future.delayed(const Duration(seconds: 1));

    final result = await _chatService.sendPhotoAsMessageToTheSelectedUser(
      channelId: channelId!,
      pathOfTheTakenPhoto: pathOfTheTakenPhoto,
      sizeOfTheTakenPhoto: sizeOfTheTakenPhoto,
    );

    result.fold(
      (failure) => emit(state.copyWith(isInProgress: false, isCapturedPhotoSent: false, error: failure)),
      (_) => emit(state.copyWith(isInProgress: false, isCapturedPhotoSent: true)),
    );
  }

  Future<void> createNewChannel({
    required bool isCreateNewChatPageForCreatingGroup,
  }) async {
    if (state.isInProgress) {
      return;
    }

    String channelImageUrl = '';
    String channelName = state.channelName;
    final listOfMemberIDs = {...state.listOfSelectedUserIDs};

    final currentUserId = _authCubit.state.authUser.id;
    listOfMemberIDs.add(currentUserId);

    if (isCreateNewChatPageForCreatingGroup) {
      // If page opened for creating group case:
      // We can directly enter the group name and upload the image.
      channelName = state.channelName;
      channelImageUrl = randomGroupProfilePhoto;
    } else if (!isCreateNewChatPageForCreatingGroup) {
      // If page opened for creating [1-1 chat] case:
      // Channel name will be selected user's name, and the image of the channel
      // will be image of the selected user.

      if (listOfMemberIDs.length == 2) {
        final String selectedUserId = listOfMemberIDs.where((memberIDs) => memberIDs != currentUserId).toList().first;

        final selectedUserFromFirestore = await _firebaseFirestore.userDocument(userId: selectedUserId);

        final getSelectedUserDataFromFirestore = await selectedUserFromFirestore.get();

        final selectedUserData = getSelectedUserDataFromFirestore.data() as Map<String, dynamic>?;

        channelName = selectedUserData?['displayName'];

        channelImageUrl = selectedUserData?['photoUrl'];
      }
    }

    final isChannelNameValid = !isCreateNewChatPageForCreatingGroup ? true : state.isChannelNameValid;

    if (listOfMemberIDs.length >= 2 && isChannelNameValid) {
      emit(state.copyWith(isInProgress: true, isChannelCreated: false));

      final result = await _chatService.createNewChannel(
        listOfMemberIDs: listOfMemberIDs.toList(),
        channelName: channelName,
        channelImageUrl: channelImageUrl,
      );

      result.fold(
        (failure) => emit(state.copyWith(isInProgress: false, isChannelCreated: false, error: failure)),
        (_) => emit(state.copyWith(isInProgress: false, isChannelCreated: true)),
      );
    }
  }

  void selectUserWhenCreatingAGroup({
    required User user,
    required bool isCreateNewChatPageForCreatingGroup,
  }) {
    final listOfSelectedUserIDs = {...state.listOfSelectedUserIDs};
    final listOfSelectedUsers = {...state.listOfSelectedUsers};

    if (!isCreateNewChatPageForCreatingGroup) {
      if (listOfSelectedUserIDs.isEmpty) {
        listOfSelectedUserIDs.add(user.id);
        listOfSelectedUsers.add(user);
      }
      emit(
        state.copyWith(
          listOfSelectedUserIDs: listOfSelectedUserIDs,
          listOfSelectedUsers: listOfSelectedUsers,
        ),
      );
    } else if (isCreateNewChatPageForCreatingGroup) {
      listOfSelectedUserIDs.add(user.id);
      listOfSelectedUsers.add(user);

      emit(
        state.copyWith(
          listOfSelectedUserIDs: listOfSelectedUserIDs,
          listOfSelectedUsers: listOfSelectedUsers,
        ),
      );
    }
  }

  void selectUserToSendCapturedPhoto({
    required User user,
    required int userIndex,
  }) {
    final listOfSelectedUserIDs = {...state.listOfSelectedUserIDs};

    if (listOfSelectedUserIDs.isEmpty) {
      listOfSelectedUserIDs.add(user.id);
    }

    emit(state.copyWith(listOfSelectedUserIDs: listOfSelectedUserIDs, userIndex: userIndex));
  }

  void removeUserToSendCapturedPhoto({
    required User user,
  }) {
    final listOfSelectedUserIDs = {...state.listOfSelectedUserIDs};

    listOfSelectedUserIDs.remove(user.id);

    emit(state.copyWith(listOfSelectedUserIDs: listOfSelectedUserIDs, userIndex: 0));
  }

  /// If there is no a searched channel in the list of channels, then return false. If there is, return true.
  bool searchInsideExistingChannels({
    required List<Channel> listOfChannels,
    required String searchedText,
    required int index,
    required int lengthOfTheChannelMembers,
    required User oneToOneChatMember,
  }) {
    int result;
    final editedSearchedText = searchedText.toLowerCase().trim();

    if (lengthOfTheChannelMembers == 2) {
      final filteredChannels = listOfChannels
          .where(
            (channel) => oneToOneChatMember.name.toLowerCase().trim().contains(editedSearchedText),
          )
          .toList();

      result = filteredChannels.indexOf(listOfChannels[index]);
    } else {
      final filteredChannels = listOfChannels
          .where(
            (channel) => channel.name!.toLowerCase().trim().contains(editedSearchedText),
          )
          .toList();

      result = filteredChannels.indexOf(listOfChannels[index]);
    }

    if (result == -1) {
      return false;
    } else {
      return true;
    }
  }
}
