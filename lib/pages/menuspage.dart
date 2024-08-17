import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/menuscont/aboutus.dart';
import 'package:trip_to_kumari/menuscont/developers.dart';
import 'package:trip_to_kumari/menuscont/privacy-policy.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

void main() {
  runApp(MaterialApp(
    home: MenusPage(),
  ));
}

class MenusPage extends StatelessWidget {
  MenusPage({Key? key}) : super(key: key);

  final Map<String, Widget> routes = {
    'About Us': const AboutUsPage(),
    'Developers team': DevelopersPage(),
    'Privacy Policy': const PrivacyPolicy()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              Image.asset(
                BaseProp.menuTitleLogo,
                height: ImageSizeScaler.scaleImageSize(context, 100),
                width: ImageSizeScaler.scaleImageSize(context, 400),
              ),
              Text(
                BaseProp.appName.toUpperCase(),
                style: GoogleFonts.inknutAntiqua(
                  fontSize: TextSizeScaler.scaleTextSize(context, 18),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                BaseProp.appDescription,
                style: GoogleFonts.imprima(
                  fontSize: TextSizeScaler.scaleTextSize(context, 12),
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          const SizedBox(height: 35),
          ...List.generate(
            customListTiles.length,
            (index) {
              final tile = customListTiles[index];
              return Padding(
                padding: ResponsivePadding.fromLTRB(context, 5, 5, 5, 5),
                child: Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  child: GestureDetector(
                    onTap: () {
                      final selectedTitle = customListTiles[index].title;
                      final nextPage = routes[selectedTitle];
                      if (nextPage != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => nextPage),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(
                        tile.icon,
                        color: const Color.fromARGB(255, 32, 100, 231),
                        size: IconSizeScaler.scaleIconSize(context, 24.0),
                      ),
                      title: Text(
                        tile.title,
                        style: GoogleFonts.imprima(
                          fontSize: TextSizeScaler.scaleTextSize(context, 12),
                          color: const Color.fromARGB(255, 32, 100, 231),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: const Color.fromARGB(255, 32, 100, 231),
                          size: IconSizeScaler.scaleIconSize(context, 24.0)),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          Text(
            'Ver ${BaseProp.appVersion}',
            style: GoogleFonts.imprima(
              fontSize: TextSizeScaler.scaleTextSize(context, 12),
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            'Last Updated: ${BaseProp.lastUpdateDate}',
            style: GoogleFonts.imprima(
              fontSize: TextSizeScaler.scaleTextSize(context, 12),
              color: const Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30)
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class CustomListTile {
  final IconData icon;
  final String title;
  CustomListTile({
    required this.icon,
    required this.title,
  });
}

List<CustomListTile> customListTiles = [
  CustomListTile(
    icon: (BootstrapIcons.person),
    title: "About Us",
  ),
  CustomListTile(
    title: "Privacy Policy",
    icon: (BootstrapIcons.shield_check),
  ),
  CustomListTile(
    title: "Developers team",
    icon: (BootstrapIcons.code_slash),
  ),
  CustomListTile(
    icon: (BootstrapIcons.person_lines_fill),
    title: "Contact Us",
  ),
];
