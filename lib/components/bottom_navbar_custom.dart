import 'dart:io';

import 'package:flutter/material.dart';

class BottomNavbarCustom extends StatefulWidget {
  final List<BottomNavbarCustomItem> items;
  final ValueChanged<int> onIndexChange;
  final EdgeInsetsGeometry padding;
  final selectedIndex;
  final backgroundColor;
  final splashColor;
  final Color selectedColor;
  final Color deselectedColor;

  BottomNavbarCustom({
    @required this.items,
    this.onIndexChange,
    this.padding,
    this.splashColor,
    this.selectedIndex,
    this.backgroundColor,
    this.deselectedColor = Colors.black54,
    this.selectedColor = Colors.red,
  });
  _BottomNavbarCustomState createState() => _BottomNavbarCustomState();
}

class _BottomNavbarCustomState extends State<BottomNavbarCustom> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? Platform.isIOS ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 18.0) : EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      color: widget.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.items.map((item) {
            int index = widget.items.indexOf(item);
            return Expanded(
            
              child: InkWell(
                splashColor: widget.splashColor ?? Colors.black12,
                borderRadius: BorderRadius.circular(50.0),
                onLongPress: () {},
                onTap: () {
                  widget.onIndexChange(index);
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        item.icon,
                        size: 25.0,
                        color: index == widget.selectedIndex ? widget.selectedColor : widget.deselectedColor,
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        item.text,
                        style:
                            TextStyle(fontSize: 9.0, color: index == widget.selectedIndex ? widget.selectedColor : widget.deselectedColor),
                      )
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class BottomNavbarCustomItem {
  final String text;
  final IconData icon;

  BottomNavbarCustomItem({
    this.icon,
    this.text,
  });
}
