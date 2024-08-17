import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/data/place.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/pages/place_details.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class CatListPage extends StatefulWidget {
  final String catName, catImage;

  CatListPage({required this.catName, required this.catImage});
  @override
  _CatListPageState createState() => _CatListPageState();
}

class _CatListPageState extends State<CatListPage> {
  List<Place> allPlaces = [];
  List<Place> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _loadPlacesData();
  }

  Future<void> _loadPlacesData() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final placeFiles = manifestMap.keys
        .where((String key) =>
            key.contains('${BaseProp.catJsonpath}/${widget.catName}/'))
        .toList();

    for (final assetPath in placeFiles) {
      final jsonData = await rootBundle.loadString(assetPath);
      final jsonMap = json.decode(jsonData);
      final place = Place.fromJson(jsonMap);
      allPlaces.add(place);
    }

    setState(() {
      _filteredPlaces = allPlaces;
    });
  }

  List<Place> _filterPlaces(List<Place> places, String query) {
    query = query.toLowerCase();
    return places
        .where((place) => place.name.toLowerCase().contains(query))
        .toList();
  }

  void navigateToPlaceDetails(BuildContext context, Place selectedPlace) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailPage(selectedPlace: selectedPlace),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    // Customize this behavior as needed
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      return Future.value(false);
    } else {
      // Prevent exiting the app
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = screenWidth > 600 ? 3 : 2;

    double childAspectRatio = screenWidth > 600 ? 0.7 : 0.85;
    double crossAxisSpacing = screenWidth > 600 ? 30.0 : 30.0;
    double mainAxisSpacing = screenWidth > 600 ? 16.0 : 20.0;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  height: ContainerScaler.getContainerHeight(context, 70),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          '${BaseProp.catImgpath}/${widget.catImage}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 0, 84, 223)
                              .withOpacity(0.2),
                          const Color.fromARGB(255, 0, 54, 141)
                              .withOpacity(0.9),
                        ],
                        stops: [0.0, 0.9],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: ResponsiveMargin.fromLTRB(context, 0, 16, 16, 16),
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconSize: 25,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        icon: const Icon(Ionicons.chevron_back),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.catName.toUpperCase(),
                        style: GoogleFonts.inknutAntiqua(
                          fontSize: TextSizeScaler.scaleTextSize(context, 20),
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin:
                            ResponsiveMargin.fromLTRB(context, 16, 16, 16, 0),
                        padding:
                            ResponsivePadding.fromLTRB(context, 3, 3, 3, 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _filteredPlaces = _filterPlaces(allPlaces, value);
                            });
                          },
                          style: GoogleFonts.imprima(
                            fontSize: TextSizeScaler.scaleTextSize(context, 16),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Search",
                            contentPadding: EdgeInsets.all(15),
                            suffixIcon: Icon(
                              Ionicons.search,
                              color: Color.fromARGB(255, 32, 100, 231),
                              size: 24,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          cursorColor: const Color.fromARGB(255, 32, 100, 231),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
            sliver: _filteredPlaces.isNotEmpty
                ? SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: crossAxisSpacing,
                      mainAxisSpacing: mainAxisSpacing,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final place = _filteredPlaces[index];
                        return GestureDetector(
                          onTap: () => navigateToPlaceDetails(context, place),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            padding: ResponsivePadding.fromLTRB(
                                context, 10, 10, 10, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                    '${BaseProp.plcImgpath}/${place.image[0]}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                  ),
                                  child: Text(
                                    place.name,
                                    style: GoogleFonts.roboto(
                                      fontSize: TextSizeScaler.scaleTextSize(
                                          context, 15),
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredPlaces.length,
                    ),
                  )
                : const SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No places found.',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
          )
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    )
    );
  }
}
