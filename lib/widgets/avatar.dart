import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:only_kids/models/user_profile.dart';

String getPlaceholderChar(List<String> placeholderCharSources) => placeholderCharSources
    .firstWhere((String str) => str != null && str.trimLeft().isNotEmpty)
    .trimLeft()[0]
    .toUpperCase();

class Avatar extends StatelessWidget {
  const Avatar({
    Key key,
    @required this.avatarSize,
    @required this.userProfile,
    this.onTap,
  }) : super(key: key);

  final double avatarSize;
  final Function onTap;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final List<String> placeholderCharSources = <String>[
      userProfile.displayName,
      userProfile.email,
      '-',
    ];
    final String placeholderChar = getPlaceholderChar(placeholderCharSources);

    return CircleAvatar(
      radius: avatarSize / 2,
      child: InkWell(
        onTap: onTap == null ? null : () => onTap(context),
        child: userProfile.photoUrl == null
            ? Text(placeholderChar)
            : Container(
                width: avatarSize,
                height: avatarSize,
                child: ClipOval(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircleAvatar(
                      child: Text(placeholderChar),
                    ),
                    imageUrl: userProfile.photoUrl,
                  ),
                ),
              ),
      ),
    );
  }
}
