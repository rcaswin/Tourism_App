import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/sliders/data.dart';

class HomeSlider extends StatelessWidget {
  const HomeSlider({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = SliderMediaQueryService(context).screenHeight;

    return CarouselSlider(
      items: imageDataList.map((imageData) {
        return Stack(
          children: [
            // Image
            Container(
              margin: const EdgeInsets.all(6.0),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(
                  image: AssetImage(
                    '${BaseProp.homeSliderImgPath}/${imageData.imageUrl}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Blurred overlay
            Positioned(
              bottom: 20,
              left: 40,
              right: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    margin: ResponsiveMargin.fromLTRB(context, 1, 3, 1, 3),
                    padding: ResponsivePadding.fromLTRB(context, 5, 5, 5, 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      imageData.text.toUpperCase(),
                      style: GoogleFonts.imprima(
                        fontSize: TextSizeScaler.scaleTextSize(context, 15),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
      options: CarouselOptions(
        height: screenHeight * 0.5,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 9 / 16,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 1500),
        viewportFraction: 0.8,
      ),
    );
  }
}
