import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int selectedIndex = 0;

  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.person,
    Icons.shopping_cart,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Container(
      height: 100 + bottomPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 27, 31, 37),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 30,
          bottom: bottomPadding + 10, 
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(icons.length, (index) {
            final isActive = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.blue
                      : const Color.fromARGB(255, 27, 31, 37),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: const Offset(6, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icons[index],
                  size: 28,
                  color: isActive ? Colors.white : Colors.white70,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}