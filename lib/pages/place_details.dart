// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:trip_to_kumari/baseproperty.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';
import 'package:trip_to_kumari/data/place.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PlaceDetailPage extends StatefulWidget {
  final Place selectedPlace;
  PlaceDetailPage({required this.selectedPlace});

  @override
  _PlaceDetailPageState createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  bool isLiked = false;
  int currentIndex = 0;
  List<String> imageList = [];

  Widget displayOrNA(String data) {
    if (data.isNotEmpty) {
      return Text(
        data,
        style: GoogleFonts.roboto(
          fontSize: TextSizeScaler.scaleTextSize(context, 14),
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.justify,
        maxLines: null,
      );
    } else {
      return Text(
        "NA",
        style: GoogleFonts.roboto(
          fontSize: TextSizeScaler.scaleTextSize(context, 14),
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        textAlign: TextAlign.justify,
        maxLines: null,
      );
    }
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
    final latLongString = widget.selectedPlace.latlongvalue;
    final latLongList = latLongString.split(', ');
    final latitude = double.parse(latLongList[0]);
    final longitude = double.parse(latLongList[1]);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
      body: SafeArea(
        child: ListView(
          padding:
              const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 25),
          children: <Widget>[
            SizedBox(
              height: ContainerScaler.getContainerHeight(context, 170),
              width: double.maxFinite,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: AssetImage(
                            '${BaseProp.plcImgpath}/${widget.selectedPlace.image[0]}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      padding: ResponsivePadding.fromLTRB(context, 3, 3, 3, 3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize:
                                IconSizeScaler.scaleIconSize(context, 24.0),
                            color: const Color.fromARGB(255, 32, 100, 231),
                            icon: const Icon(Ionicons.chevron_back),
                          ),
                          IconButton(
                            iconSize:
                                IconSizeScaler.scaleIconSize(context, 24.0),
                            onPressed: () {
                              setState(() {
                                isLiked = !isLiked;
                              });
                            },
                            icon: Icon(isLiked
                                ? Ionicons.heart
                                : Ionicons.heart_outline),
                            color: const Color.fromARGB(255, 32, 100, 231),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.selectedPlace.name,
                        style: GoogleFonts.imprima(
                          fontSize: TextSizeScaler.scaleTextSize(context, 20),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.selectedPlace.location,
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 11),
                          color: const Color.fromARGB(255, 77, 77, 77),
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Description",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 18),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedPlace.description
                            .map((description) => Text(
                                  description,
                                  style: GoogleFonts.roboto(
                                    fontSize: TextSizeScaler.scaleTextSize(
                                        context, 14),
                                    color: Colors.black,
                                    height: 2,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.justify,
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Contact Details",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      displayOrNA('Name: ' +
                          (widget.selectedPlace.contactdetails['name'] ??
                              'NA')),
                      displayOrNA('Mail ID: ' +
                          (widget.selectedPlace.contactdetails['email'] ??
                              'NA')),
                      displayOrNA('Mobile No: ' +
                          (widget.selectedPlace.contactdetails['mobileno'] ??
                              'NA')),
                      const SizedBox(height: 10),
                      Text(
                        "Visiting Time",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      displayOrNA('Opening Time: ' +
                          (widget.selectedPlace.visitingtime['starttime'] ??
                              'NA')),
                      displayOrNA('Closing Time: ' +
                          (widget.selectedPlace.visitingtime['closingtime'] ??
                              'NA')),
                      const SizedBox(height: 10),
                      Text(
                        "Holidays",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.justify,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedPlace.holiday
                            .map((holiday) => Text(
                                  holiday,
                                  style: GoogleFonts.roboto(
                                    fontSize: TextSizeScaler.scaleTextSize(
                                        context, 14),
                                    color: Colors.black,
                                    height: 2,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Official Links",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedPlace.links
                            .map((links) => Text(
                                  links,
                                  style: GoogleFonts.roboto(
                                    fontSize: TextSizeScaler.scaleTextSize(
                                        context, 14),
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Entry Fees",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedPlace.entryfee
                            .map((entryfee) => Text(
                                  entryfee,
                                  style: GoogleFonts.roboto(
                                    fontSize: TextSizeScaler.scaleTextSize(
                                        context, 14),
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Map View",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: ContainerScaler.getContainerHeight(context, 70),
                        child: FlutterMap(
                          options: MapOptions(
                            zoom: 10,
                            center: LatLng(latitude, longitude),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                              userAgentPackageName: '',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(latitude, longitude),
                                  width: 50,
                                  height: 50,
                                  builder: (context) => ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 32, 100, 231),
                                          Color.fromARGB(255, 32, 100, 231),
                                        ],
                                      ).createShader(
                                          const Rect.fromLTWH(0, 0, 45, 45));
                                    },
                                    child: const Column(
                                      children: [
                                        Icon(
                                          Ionicons.location_sharp,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Gallery View",
                        style: GoogleFonts.roboto(
                          fontSize: TextSizeScaler.scaleTextSize(context, 14),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          _showImageSlideshow(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height:
                              ContainerScaler.getContainerHeight(context, 60),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.selectedPlace.image.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  '${BaseProp.plcImgpath}/${widget.selectedPlace.image[index]}',
                                  width: ContainerScaler.getContainerWidth(
                                      context, 100),
                                  height: ContainerScaler.getContainerHeight(
                                      context, 100),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(),
    )
    );
  }

  void _showImageSlideshow(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.black,
            body: Center(
              child: Container(
                height: ContainerScaler.getContainerHeight(context, 200),
                width: double.maxFinite,
                child: PhotoViewGallery.builder(
                  itemCount: widget.selectedPlace.image.length,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: AssetImage(
                        '${BaseProp.plcImgpath}/${widget.selectedPlace.image[index]}',
                      ),
                      minScale: PhotoViewComputedScale.covered,
                      maxScale: PhotoViewComputedScale.covered,
                    );
                  },
                  scrollPhysics: const ScrollPhysics(),
                  backgroundDecoration: const BoxDecoration(
                    color: Color.fromARGB(255, 239, 245, 253),
                  ),
                  pageController: PageController(initialPage: currentIndex),
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          )
          );
        },
      ),
    );
  }
}
