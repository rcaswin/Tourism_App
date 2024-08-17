import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/data/service_data.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/models/horizontal_scroll_category_list.dart';
import 'package:trip_to_kumari/models/services_gird.dart';
import 'package:trip_to_kumari/pages/explorepage.dart';
import 'package:trip_to_kumari/sliders/home.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 16, 16, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    BaseProp.apptnLogo,
                    height: ImageSizeScaler.scaleImageSize(context, 50),
                    width: ImageSizeScaler.scaleImageSize(context, 50),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          BaseProp.appName,
                          style: GoogleFonts.inknutAntiqua(
                            fontSize: TextSizeScaler.scaleTextSize(context, 20),
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          BaseProp.appDescription,
                          style: GoogleFonts.imprima(
                            fontSize: TextSizeScaler.scaleTextSize(context, 12),
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  ClipOval(
                    child: Image.asset(
                      BaseProp.namaKumariLogo,
                      height: ImageSizeScaler.scaleImageSize(context, 50),
                      width: ImageSizeScaler.scaleImageSize(context, 50),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            const HomeSlider(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Services",
                    style: GoogleFonts.inknutAntiqua(
                      fontSize: TextSizeScaler.scaleTextSize(context, 20),
                      color: const Color.fromARGB(255, 41, 41, 41),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            ServiceGrid(services: services),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore",
                    style: GoogleFonts.inknutAntiqua(
                      fontSize: TextSizeScaler.scaleTextSize(context, 20),
                      color: const Color.fromARGB(255, 41, 41, 41),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ExplorePage()),
                      );
                    },
                    child: Text(
                      "See All",
                      style: GoogleFonts.imprima(
                        fontSize: TextSizeScaler.scaleTextSize(context, 13),
                        color: const Color.fromARGB(255, 41, 41, 41),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 0),
            const HorzScrlCategoryList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}
