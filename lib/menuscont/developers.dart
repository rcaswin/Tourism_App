import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class Developers {
  final String title;
  final String name;
  final String designation;
  final String email;
  final String profile;
  final String imageUrl;

  Developers({
    required this.title,
    required this.name,
    required this.designation,
    required this.email,
    required this.profile,
    required this.imageUrl,
  });
}

// ignore: must_be_immutable
class DevelopersPage extends StatelessWidget {
  List<Developers> developers = [
    Developers(
      title: "Project Lead",
      name: "Siva M",
      designation: "App Developer",
      email: "sivamuralidharan.6@gmail.com",
      profile: "https://www.linkedin.com/in/-siva-m-2002-/",
      imageUrl:
          "https://media.licdn.com/dms/image/D5603AQE8gkhb2j77jA/profile-displayphoto-shrink_400_400/0/1697858315972?e=1706745600&v=beta&t=r8H-SbI4ki3CpARjgr_o1T1ZfkSLM_1o9b8fVgNj-Q8",
    ),
    Developers(
      title: "Design Lead",
      name: "Sreejith S",
      designation: "UI/UX Designer",
      email: "srees2002f@gmail.com",
      profile: "https://www.linkedin.com/in/sreejith-s-80293b219/",
      imageUrl:
          "https://media.licdn.com/dms/image/C5603AQG5yelRVE2fQw/profile-displayphoto-shrink_400_400/0/1642063870313?e=1706745600&v=beta&t=vjZwi7Y8rPO35n1dhNHz3TWr5ukmvLf-O4j8RaiJJ_I",
    ),
    Developers(
      title: "Design Lead",
      name: "Vishnu C",
      designation: "App Development",
      email: "vishnu2003cl@gmail.com",
      profile: "https://www.linkedin.com/in/c-vishnu-7a75a3227",
      imageUrl:
          "https://img.freepik.com/premium-vector/user-profile-icon-flat-style-member-avatar-vector-illustration-isolated-background-human-permission-sign-business-concept_157943-15752.jpg",
    ),
  ];

  DevelopersPage({super.key});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
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
                    "Developers Information",
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
                  Image.asset(
                    BaseProp.ucenLogo,
                    height: ImageSizeScaler.scaleImageSize(context, 120),
                    width: ImageSizeScaler.scaleImageSize(context, 120),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.clgname,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.devDesc,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Infomation',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    BaseProp.clgname,
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Mail: ${BaseProp.contactmail}',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 14),
                      color: Colors.black,
                      height: 1.5,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Developers',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Meet the talented individuals behind Trip to Kumari:',
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: developers.length,
                itemBuilder: (context, index) {
                  return buildCard(context, developers[index]);
                },
              ),
            ),
            Padding(
              padding: ResponsivePadding.fromLTRB(context, 16, 0, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Open Source Contributions',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.opensrccont,
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
                    'Feedback & Collaboration',
                    style: GoogleFonts.imprima(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    BaseProp.feedbackcont,
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  Widget buildCard(BuildContext context, Developers developer) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        developer.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TextSizeScaler.scaleTextSize(context, 15),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        developer.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TextSizeScaler.scaleTextSize(context, 18),
                        ),
                      ),
                      Text(
                        developer.designation,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize:
                                TextSizeScaler.scaleTextSize(context, 13)),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Mail: ${developer.email}',
                        style: TextStyle(
                          fontSize: TextSizeScaler.scaleTextSize(context, 15),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Positioned(
                  top: 0,
                  right: 30,
                  child: ClipOval(
                    child: Image.network(
                      developer.imageUrl,
                      height: ImageSizeScaler.scaleImageSize(context, 80),
                      width: ImageSizeScaler.scaleImageSize(context, 80),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: TextButton(
                onPressed: () async {
                  String url = developer.profile;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
