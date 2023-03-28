import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peppers_admin_panel/presentation/config/constants.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile(
      {Key? key,
      required this.title,
      required this.iconPath,
      required this.onTap,
      this.isActive = false})
      : super(key: key);

  final String title;
  final String iconPath;
  final Function() onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: Constants.defaultPadding * 0.5,
          right: Constants.defaultPadding * 0.5,
          bottom: Constants.defaultPadding * 0.25),
      child: ListTile(
        onTap: onTap,
        tileColor:
            isActive ? Constants.primaryColor : Constants.secondBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: SvgPicture.asset(
          iconPath,
          color:
              isActive ? Constants.buttonTextColor : Constants.middleGrayColor,
          width: 20,
        ),
        horizontalTitleGap: 0,
        title: Text(
          title,
          style: Constants.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: isActive
                  ? Constants.buttonTextColor
                  : Constants.middleGrayColor,
              fontSize: 13),
        ),
      ),
    );
  }
}
