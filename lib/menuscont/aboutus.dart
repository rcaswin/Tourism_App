import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(top: statusBarHeight + 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 25,
              color: const Color.fromARGB(255, 0, 0, 0),
              icon: const Icon(Ionicons.chevron_back),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About Us',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: const Color.fromARGB(255, 41, 41, 41),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Image.asset(
                    BaseProp.apptnLogo,
                    height: ImageSizeScaler.scaleImageSize(context, 60),
                    width: ImageSizeScaler.scaleImageSize(context, 60),
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.appName,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.aboutUscont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 15),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Our Purpose',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.ourPurposecont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 15),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Key Features',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Interactive Maps',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.mapembedcont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Chatbot Assistance',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.chatbotcont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Visual Delight',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.visualDelightcont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Target Audience',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.targetaudience,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'About ${BaseProp.clgname}',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.aboutclgcont,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
