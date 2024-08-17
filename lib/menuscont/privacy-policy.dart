import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
              padding: ResponsivePadding.fromLTRB(context, 20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Privacy Policy',
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
              padding: ResponsivePadding.fromLTRB(context, 20, 0, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Latest Update : ${BaseProp.lastUpdateDate}',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Introduction'.toUpperCase(),
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.privacyIntro,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Information We Collect'.toUpperCase(),
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '1. Location Information',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.loctioninfo,
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
                    '2. File Access',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.fileaccess,
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
