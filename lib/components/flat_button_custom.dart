import 'package:flutter/material.dart';
import 'package:float/models_providers/theme_provider.dart';
import 'package:provider/provider.dart';

class FlatButtonCustom extends StatelessWidget {
  final GestureTapCallback onTap;
  final IconData iconData;
  final Color iconColor;
  final String title;
  final Color titleColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color color;
  final bool isOutlined;
  final bool showBorder;
  final bool isEnabled;

  FlatButtonCustom({
    @required this.title,
    @required this.onTap,
    this.titleColor,
    this.isOutlined = false,
    this.showBorder = false,
    this.iconData,
    this.margin,
    this.borderRadius,
    this.color,
    this.padding,
    this.iconColor,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: 56,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        child: Container(
          decoration: isOutlined
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius ?? 20),
                  border: Border.all(
                    color: color ?? themeProvider.getThemeData.buttonColor,
                    width: 1.75,
                    style: showBorder ? BorderStyle.solid : BorderStyle.none,
                  ),
                )
              : BoxDecoration(
                  color: color ?? themeProvider.getThemeData.buttonColor, borderRadius: BorderRadius.circular(borderRadius ?? 20)),
          padding: padding ?? EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (iconData != null)
                Icon(
                  iconData,
                  color: iconColor ?? Colors.white,
                  size: 20,
                ),
              if (iconData != null)
                SizedBox(
                  width: 20,
                ),
              Text(
                title ?? '',
                style: TextStyle(
                  fontSize: 14.5,
                  color: titleColor ?? Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
