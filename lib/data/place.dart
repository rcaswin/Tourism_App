class Place {
  final String name;
  final List<String> description;
  final List<String> image;
  final String location;
  final String categorycodes;
  final String districtcode;
  final String latlongvalue;
  final List<String> keywords;
  final Map<String, dynamic> contactdetails;
  final List<String> links;
  final Map<String, dynamic> visitingtime;
  final List<String> holiday;
  final List<String> entryfee;

  Place({
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.categorycodes,
    required this.districtcode,
    required this.latlongvalue,
    required this.keywords,
    required this.contactdetails,
    required this.links,
    required this.visitingtime,
    required this.holiday,
    required this.entryfee,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'NA',
      description: List<String>.from(json['description'] ?? ['NA']),
      image: List<String>.from(json['image'] ?? ['NA']),
      location: json['location'] ?? 'NA',
      categorycodes: json['categorycodes'] ?? 'NA',
      districtcode: json['districtcode'] ?? 'NA',
      latlongvalue: json['latlongvalue'] ?? 'NA',
      keywords: List<String>.from(json['keywords'] ?? ['NA']),
      contactdetails: json['contactdetails'] ?? <String, dynamic>{'NA': 'NA'},
      links: List<String>.from(json['links'] ?? ['NA']),
      visitingtime: json['visitingtime'] ?? <String, dynamic>{'NA': 'NA'},
      holiday: List<String>.from(json['holiday'] ?? ['NA']),
      entryfee: List<String>.from(json['entryfee'] ?? ['NA']),
    );
  }
}
