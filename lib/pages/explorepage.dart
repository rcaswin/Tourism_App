import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/pages/catlist.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> _allCategories = [];
  List<Map<String, dynamic>> _listOfCategories = [];

  void _onUserSelected(String catName, catImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatListPage(catName: catName, catImage: catImage),
      ),
    );
  }

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    final String usersData =
        await DefaultAssetBundle.of(context).loadString('assets/category.json');
    final List<dynamic> usersJson = json.decode(usersData);

    final List<Map<String, dynamic>> categories =
        usersJson.cast<Map<String, dynamic>>();

    setState(() {
      _allCategories = categories;
      _listOfCategories = categories;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCategories;
    } else {
      results = _allCategories
          .where((category) => category["name"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _listOfCategories = results;
    });
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      body: Column(
        children: [
          Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                height: ContainerScaler.getContainerHeight(context, 70),
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(BaseProp.exploreImg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 0, 84, 223).withOpacity(0.6),
                        const Color.fromARGB(255, 0, 54, 141).withOpacity(0.3),
                      ],
                      stops: const [0.0, 0.9],
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
                      "Explore",
                      style: GoogleFonts.inknutAntiqua(
                        fontSize: TextSizeScaler.scaleTextSize(context, 20),
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: ResponsiveMargin.fromLTRB(context, 16, 16, 16, 0),
                      padding: ResponsivePadding.fromLTRB(context, 3, 3, 3, 3),
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
                          _runFilter(value);
                        },
                        style: GoogleFonts.imprima(
                          fontSize: TextSizeScaler.scaleTextSize(context, 16),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search",
                          contentPadding: EdgeInsets.all(15),
                          suffixIcon: Icon(
                            Ionicons.search,
                            color: const Color.fromARGB(255, 32, 100, 231),
                            size: IconSizeScaler.scaleIconSize(context, 24.0),
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
          Expanded(
            child: _listOfCategories.isNotEmpty
                ? ListView.builder(
                    itemCount: _listOfCategories.length,
                    itemBuilder: (context, index) => Card(
                      color: Colors.transparent,
                      elevation: 0,
                      margin: ResponsiveMargin.fromLTRB(context, 3, 0, 3, 16),
                      child: ListTile(
                        onTap: () {
                          _onUserSelected(_listOfCategories[index]['name'],
                              _listOfCategories[index]['image']);
                        },
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: AssetImage(
                            '${BaseProp.catImgpath}/${_listOfCategories[index]['image']}',
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(
                          _listOfCategories[index]['name'].toUpperCase(),
                          style: GoogleFonts.roboto(
                            fontSize: TextSizeScaler.scaleTextSize(context, 15),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _listOfCategories[index]['des'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: TextSizeScaler.scaleTextSize(context, 12),
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'No results found. Please try with a different One',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    )
    );
  }
}
