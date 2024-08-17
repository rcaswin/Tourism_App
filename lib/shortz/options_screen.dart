import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/img/logo.png'),
              ),
              const SizedBox(width: 6),
              Text(
                "Trip to Kumari",
                style: GoogleFonts.imprima(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.verified,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "OFFICIAL Offical Tourism Mobile app for KanniyaKumari",
                  style: GoogleFonts.imprima(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 5),
                Text(
                  "Developed by Dept.IT, University College of Engineering Nagercoil.",
                  style: GoogleFonts.imprima(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
