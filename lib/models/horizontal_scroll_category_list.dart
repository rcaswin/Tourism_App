import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/pages/catlist.dart';

class HorzScrlCategoryList extends StatefulWidget {
  const HorzScrlCategoryList({Key? key}) : super(key: key);

  @override
  State<HorzScrlCategoryList> createState() => _HorzScrlCategoryListState();
}

class _HorzScrlCategoryListState extends State<HorzScrlCategoryList> {
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _listOfCategories.isNotEmpty
            ? _listOfCategories
                .map(
                  (category) => Card(
                    color: Colors.transparent,
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        _onUserSelected(category['name'], category['image']);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width:
                                ContainerScaler.getContainerWidth(context, 150),
                            height: ContainerScaler.getContainerHeight(
                                context, 100),
                            margin:
                                ResponsiveMargin.fromLTRB(context, 8, 0, 8, 0),
                            alignment: Alignment.bottomCenter,
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: AssetImage(
                                    '${BaseProp.catImgpath}/${category['image']}'),
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
                                    category['name'].toUpperCase(),
                                    style: GoogleFonts.imprima(
                                      fontSize: TextSizeScaler.scaleTextSize(
                                          context, 12),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList()
            : const [
                Center(
                  child: Text(
                    'No results found. Please try with a different one.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
      ),
    );
  }
}
