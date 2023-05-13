
import 'package:flutter/material.dart';

List<BoxShadow> shadowList = [
 BoxShadow(
    color: Colors.grey[300] ?? Colors.grey, // Provide a fallback color if Colors.grey[300] is null
    blurRadius: 30,
    offset: const Offset(0, 10),
  ),
];