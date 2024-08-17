import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class Helplines extends StatelessWidget {
  const Helplines({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 102, 231),
        title: const Text('Helplines'),
      ),
      body: ListView(
        padding: ResponsivePadding.fromLTRB(context, 16, 16, 16, 16),
        children: const [
          SizedBox(height: 5),
          HelplineItemCard('Disaster Centre', '1070'),
          HelplineItemCard('District Disaster Centre Control Room', '1077'),
          HelplineItemCard('Collectorate Board', '04652 – 279090, 279091'),
          HelplineItemCard('Police Control Room', '100'),
          HelplineItemCard('Traffic Police', '103'),
          HelplineItemCard('Medical Help Line', '104'),
          HelplineItemCard('Fire and Rescue', '101'),
          HelplineItemCard('Ambulance Help Line', '108'),
          HelplineItemCard('Ambulance (National Highways)', '1073'),
          HelplineItemCard('Child Help line', '1098'),
          HelplineItemCard('Sexual Harassment', '1091'),
          HelplineItemCard('Railway Help Line', '1512'),
          HelplineItemCard('Coastal Help Line', '1093'),
          HelplineItemCard(
              'District Emergency Centre (COVID 19)', '04652-1077 ,  231077'),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }
}

class HelplineItemCard extends StatelessWidget {
  final String title;
  final String number;

  const HelplineItemCard(this.title, this.number);

  Future<void> _makePhoneCall(String number) async {
    final String telUri = 'tel:$number';
    if (await canLaunch(telUri)) {
      await launch(telUri);
    } else {
      print('Could not make a call to $number');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () {
            _makePhoneCall(number);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.phone,
                  size: IconSizeScaler.scaleIconSize(context, 24.0),
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        title,
                        style: GoogleFonts.imprima(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        number,
                        style: GoogleFonts.imprima(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          fontWeight: FontWeight.normal,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Helplines()));
}
