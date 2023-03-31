import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:weforza/theme/appTheme.dart';
import 'package:weforza/widgets/custom/profileImage/profileImage.dart';
import 'package:weforza/widgets/pages/rideAttendeeScanningPage/manualSelection/selectableProfileImage.dart';
import 'package:weforza/widgets/platform/platformAwareLoadingIndicator.dart';

class ManualSelectionListItem extends StatelessWidget {
  ManualSelectionListItem({
    @required this.isSelected,
    @required this.onTap,
    @required this.profileImageFuture,
    @required this.firstName,
    @required this.lastName,
    @required this.phone
  }): assert(
    isSelected != null && profileImageFuture != null &&
        onTap != null && firstName != null && lastName != null && phone != null
    && isSelected != null
  );

  final ValueNotifier<bool> isSelected;
  final VoidCallback onTap;
  final Future<File> profileImageFuture;
  final String firstName;
  final String lastName;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SelectableProfileImage(
                  size: 40,
                  future: profileImageFuture,
                  onSelectedChanged: isSelected,
                  errorBuilder: (double size) => ProfileImage(
                    icon: Icons.person,
                    size: size,
                    personInitials: firstName[0] + lastName[0],
                  ),
                  imageBuilder: (double size, File image) => ProfileImage(
                    image: image,
                    icon: Icons.person,
                    size: size,
                    personInitials: firstName[0] + lastName[0],
                  ),
                  loadingBuilder: (double size) => SizedBox.expand(
                    child: SizedBox(
                      width: size,
                      height: size,
                      child: Padding(
                        padding: EdgeInsets.all(size * .1),
                        child: Center(
                          child: PlatformAwareLoadingIndicator(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      firstName,
                      style: ApplicationTheme.rideAttendeeFirstNameTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            lastName,
                            style: ApplicationTheme.rideAttendeeLastNameTextStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.phone,
                              size: 15,
                              color: ApplicationTheme.primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                  "$phone",
                                  style: ApplicationTheme.rideAttendeePhoneTextStyle
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}