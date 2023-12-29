import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubes_iot/style/color.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FaIcon(FontAwesomeIcons.barsStaggered),
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  lightOrange,
                  orange,
                ]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Warna bayangan
                spreadRadius: 0, // Radius penyebaran bayangan
                blurRadius: 5, // Radius blur bayangan
                offset: const Offset(0, 4), // Posisi bayangan (x, y)
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.4),
                child: const FaIcon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                "Search service",
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}