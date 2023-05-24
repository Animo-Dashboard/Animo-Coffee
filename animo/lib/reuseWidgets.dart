import 'package:animo/pages/errorHandling_page.dart';
import 'package:flutter/material.dart';
import 'package:animo/inAppFunctions.dart';

BoxDecoration getAppBackground() {
  return BoxDecoration(
    image: DecorationImage(
      image: const AssetImage('images/background2.png'),
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
      colorFilter: ColorFilter.mode(
        Colors.white.withOpacity(0.5),
        BlendMode.dstATop,
      ),
    ),
  );
}

BoxDecoration getBackgroundIfError(String error) {
  if (error.isNotEmpty) {
    return BoxDecoration(
      color: CustomColors.red.withAlpha(50),
      border: Border.all(
        color: CustomColors.red,
        width: 2.0,
      ),
    );
  } else {
    return const BoxDecoration();
  }
}

StatelessWidget getLeadingIcon(String title, BuildContext context) {
  if (title == "Your devices") {
    return Container(
      padding: EdgeInsets.all(10),
      child: const Image(
        image: AssetImage('images/logoSymbolWhite.png'),
        height: 1,
        width: 1,
      ),
    );
  } else {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      iconSize: 40,
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

AppBar getAppBar(BuildContext context, String pageTitle,
    [List<String>? moreMenuOptions, void Function(String value)? handleClick]) {
  if (moreMenuOptions != null) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: getLeadingIcon(pageTitle, context),
      title: Text(
        pageTitle,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
      ),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: handleClick,
          icon: const Icon(
            Icons.more_horiz_sharp,
            size: 48,
          ),
          padding: const EdgeInsets.only(right: 30),
          itemBuilder: (BuildContext context) {
            return moreMenuOptions.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: handleColorMoreMenuOptions(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  } else {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: getLeadingIcon(pageTitle, context),
      title: Text(
        pageTitle,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
      ),
    );
  }
}
