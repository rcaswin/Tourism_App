// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import '../data/service_data.dart';

class ServiceGrid extends StatelessWidget {
  final List<Service> services;

  const ServiceGrid({Key? key, required this.services});

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: ResponsivePadding.fromLTRB(context, 16, 0, 0, 16),
      child: Row(
        children: services.map((service) {
          return GestureDetector(
            onTap: () {
              navigateToPage(context, service.path);
            },
            child: Container(
              width: 80,
              height: 80,
              margin: ResponsiveMargin.fromLTRB(context, 16, 16, 16, 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromARGB(255, 244, 248, 252),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 32, 100, 231)
                        .withOpacity(0.1),
                    spreadRadius: 6,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    service.icon,
                    size: IconSizeScaler.scaleIconSize(context, 24.0),
                    color: const Color.fromARGB(255, 32, 100, 231),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.title,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 12),
                      color: const Color.fromARGB(255, 32, 100, 231),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
