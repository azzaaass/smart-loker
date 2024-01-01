import 'package:flutter/material.dart';
import 'package:tubes_iot/style/color.dart';

final cardContainer = BoxDecoration(
  color: whiteBone,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.1), // Warna bayangan
      spreadRadius: 0, // Lebar bayangan yang menyebar
      blurRadius: 5,
      offset: const Offset(3, 3),
    ),
  ],
);
