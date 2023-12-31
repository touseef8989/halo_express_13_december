import 'package:flutter/material.dart';
import '../utils/constants/custom_colors.dart';

class FABBottomAppBarItem {
  FABBottomAppBarItem({this.iconData, this.text});
  IconData? iconData;
  String? text;
}

class FABBottomAppBar extends StatefulWidget {
  FABBottomAppBar({
    this.items,
    this.centerItemText,
    this.height = 60.0,
    this.iconSize = 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.notchedShape,
    this.onTabSelected,
  }) {
//    assert(this.items.length == 2 || this.items.length == 4);
  }
  final List<FABBottomAppBarItem>? items;
  final String? centerItemText;
  final double? height;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int>? onTabSelected;

  @override
  _FABBottomAppBarState createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _selectedIndex = 0;

  _updateIndex(int index) {
    widget.onTabSelected!(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTabItem({
      FABBottomAppBarItem? item,
      int? index,
      ValueChanged<int>? onPressed,
    }) {
      Color color = _selectedIndex == index ? Colors.white : kColorLightRed;
      return Expanded(
        child: SizedBox(
          height: widget.height,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => onPressed!(index!),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(item!.iconData, color: color, size: widget.iconSize),
                  const SizedBox(height: 5.0),
                  Text(item.text!, style: TextStyle(color: color, fontSize: 12))
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> items = List.generate(widget.items!.length, (int index) {
      return _buildTabItem(
        item: widget.items![index],
        index: index,
        onPressed: _updateIndex,
      );
    });

    return BottomAppBar(
      color: kColorRed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }
}
