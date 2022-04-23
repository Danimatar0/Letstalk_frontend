import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:letstalk/utils/styles.dart';

import '../../../utils/common.dart';

///This CustomButtom class is a widget to create a custom button that can be under 2 format, with a pre title icon and without a pre title icon:
///The customizable props are: title, color and the preIcon

class CustomButton extends StatelessWidget {
  final String title;
  final Color color;
  final Icon preIcon;
  // final Size size;
  final VoidCallback? onTapCallBack;
  final String _buttonType;
  final bool? isGradientText;
  final Shader? linearGradient;
  final Color? bgColor;
  final TextStyle? textStyle;

  ///The parameters of the CustomButtom are:
  /// [title] - the title of the button (For both Format) (should be a String)
  /// [color] - the color of the button (should be a Color)
  /// [preIcon] - the icon of the pre button title (should be an icon)
  /// [size] - this is the size of the button that can be changeable (should be a Size([width],[height]))
  /// [onTapCallBack] - function that pass the OnTap() action performed callBack off the button
  /// [linearGradient] LinearGradient for foreground text inside button
  ///Default constructor (For the first button format)
  ///has no preIcon with _buttonType = 'default'
  CustomButton({
    Key? key,
    this.title = 'Button',
    this.color = PRIMARY_COLOR,
    this.linearGradient,
    this.isGradientText = false,
    this.bgColor = Colors.white,
    this.textStyle = const TextStyle(fontSize: 10),
    required this.onTapCallBack,
    // this.size = const Size(170, 40),
  })  : this.preIcon = Icon(Icons.add),
        this._buttonType = 'default',
        super(key: key);

  CustomButton.gradient({
    Key? key,
    this.title = 'Button',
    this.color = PRIMARY_COLOR,
    this.isGradientText = true,
    this.bgColor = Colors.white,
    this.linearGradient,
    this.textStyle = const TextStyle(fontSize: 10),
    required this.onTapCallBack,
    // this.size = const Size(170, 40),
  })  : this.preIcon = Icon(Icons.add),
        this._buttonType = 'default',
        super(key: key);

  ///preIcon constructor (For the second button format)
  ///has the icon path with _cardType = 'preIcon'
  CustomButton.preIcon({
    Key? key,
    this.title = 'Buttonnnn',
    this.color = PRIMARY_COLOR,
    this.linearGradient,
    this.isGradientText = false,
    this.bgColor = Colors.white,
    this.textStyle = const TextStyle(fontSize: 10),
    required this.preIcon,
    // this.size = const Size(170, 40),
    required this.onTapCallBack,
  })  : this._buttonType = 'preIcon',
        super(key: key);

  //The build function that return the button
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          //Condition to check the type of the button
          (_buttonType == 'default')
              ?
              //If the type is default then return a normal elevated button
              ElevatedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(color: color, width: 1.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(bgColor!)),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        1.sw / 166 + 1.sh / 110,
                        1.sw / 355 + 1.sh / 237,
                        1.sw / 166 + 1.sh / 110,
                        1.sw / 355 + 1.sh / 237),
                    child: Text(
                      title,
                      style: _buttonType == 'default'
                          ? TextStyle(
                              fontSize: isMobile(context)
                                  ? 16
                                  : 1.sw / 200 + 1.sh / 133,
                              fontWeight: FontWeight.bold,
                              color: color)
                          : TextStyle(
                              fontSize: isMobile(context)
                                  ? 14
                                  : 1.sw / 200 + 1.sh / 133,
                              foreground: Paint()..shader = linearGradient),
                    ),
                  ),
                  onPressed: onTapCallBack,
                )
              :
              //If the type is not default(preIcon) then return an elevated button with an icon
              ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                        BorderSide(color: color, width: 1.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(bgColor!),
                  ),
                  onPressed: onTapCallBack,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 12.5,
                        ),
                        child: preIcon,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: 10,
                        ),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 12, //1.sw / 200 + 1.sh / 133,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
