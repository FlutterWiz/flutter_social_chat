import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_chat/presentation/design_system/colors.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.userPhotoUrl});
  final String userPhotoUrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 35, bottom: 10),
      child: CachedNetworkImage(
        imageUrl: userPhotoUrl,
        imageBuilder: (context, imageProvider) => Container(
          constraints: BoxConstraints(
            maxWidth: size.height / 6.5,
            maxHeight: size.height / 6.5,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: customGreyColor600,
              width: 4,
            ),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
          constraints: BoxConstraints(
            maxWidth: size.height / 6.5,
            maxHeight: size.height / 6.5,
          ),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            border: Border.all(
              color: white,
              width: 4,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: black,
            ),
          ),
        ),
        errorWidget: (context, url, error) {
          return Container();
        },
      ),
    );
  }
}
