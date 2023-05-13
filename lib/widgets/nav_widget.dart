// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class PetTypeNavBar extends StatefulWidget {
  final List<String> petTypes;
  final Function(String) onPetTypeSelected;

  const PetTypeNavBar(
      {super.key, required this.petTypes, required this.onPetTypeSelected});

  @override
  _PetTypeNavBarState createState() => _PetTypeNavBarState();
}

class _PetTypeNavBarState extends State<PetTypeNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onPetTypeSelected(widget.petTypes[_selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var i = 0; i < widget.petTypes.length; i++)
            GestureDetector(
              onTap: () {
                _onItemTapped(i);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 26.0),
                decoration: BoxDecoration(
                  color: _selectedIndex == i
                      ? const Color.fromRGBO(198, 185, 250, 1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                ),
                child: Text(
                  widget.petTypes[i],
                  style: TextStyle(
                    color:
                        _selectedIndex == i ? Colors.white : Colors.grey[400],
                    //fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
          const Divider(
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
