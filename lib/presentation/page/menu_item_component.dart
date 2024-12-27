import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItemComponent extends StatefulWidget {
  final MenuItem menuItem;

  const MenuItemComponent({super.key, required this.menuItem});

  @override
  State<MenuItemComponent> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItemComponent> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.menuItem.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.menuItem.menuTitle == "TITAN Apps"
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Image.asset(
                    widget.menuItem.menuIcon,
                    width: 140.w,
                    height: 140.h,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.menuItem.menuColor,
                  ),
                  child: Image.asset(
                    widget.menuItem.menuIcon,
                    height: 100.h,
                    width: 100.w,
                  ),
                ),
          const SizedBox(
            height: 3,
          ),
          Text(
            widget.menuItem.menuTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final String menuTitle;
  final String menuIcon;
  final Color menuColor;
  final void Function() onTap;

  MenuItem({
    required this.menuColor,
    required this.menuTitle,
    required this.menuIcon,
    required this.onTap,
  });
}
