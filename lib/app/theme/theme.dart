import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle listTileTitle = GoogleFonts.lato(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle appBarTitle = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: const Color.fromARGB(255, 0, 15, 1),
  );

  static TextStyle buttonText = GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 0, 76, 4));
}
