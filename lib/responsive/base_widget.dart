import 'package:MyFilms/responsive/sizing_information.dart';
import 'package:MyFilms/utils/ui_utils.dart';

import 'package:flutter/material.dart';


class BaseWidget extends StatelessWidget {
  final Widget Function(
      BuildContext context, SizingInformation sizingInformation) builder;

  const BaseWidget({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var mediaQuery = MediaQuery.of(context);
    

    return LayoutBuilder(builder: (context, boxConstraints) {

      var sizingInformation = SizingInformation(
      orientation: mediaQuery.orientation,
      screenSize: mediaQuery.size,
      deviceScreenType: getDeviceType(mediaQuery),
      localWidgetSize: Size(boxConstraints.maxWidth,boxConstraints.maxHeight)
    );
    
     return builder(context, sizingInformation);
    });
  }
}
