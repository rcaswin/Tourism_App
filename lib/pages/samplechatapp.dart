import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_to_kumari/mediaquery.dart';
import 'dart:convert';
import 'package:trip_to_kumari/widgets/bottom_nav.dart';
import 'package:trip_to_kumari/pages/OpenAiApi.dart';

void main() {
  runApp(MaterialApp(
    home: TourismScreen(),
  ));
}

class ChatMessage {
  final String message;
  final bool isUser;

  ChatMessage(this.message, this.isUser);
}

class TourismScreen extends StatefulWidget {
  @override
  _TourismScreenState createState() => _TourismScreenState();
}

class _TourismScreenState extends State<TourismScreen> {
  late TextEditingController _textController;
  List<ChatMessage> chatMessages = [];
  TourismData _tourismData = TourismData([]);

  final ScrollController _listViewController = ScrollController();

  List<TourismPlace> selectedCategoryOptions = [];
  TourismPlace selectedPlace = TourismPlace('', '', '', '');

  OpenAiApi openAiApi = OpenAiApi(); // Instance of OpenAI API utility

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();

    // Load tourism data from JSON
    loadTourismData().then((tourismData) {
      setState(() {
        _tourismData = tourismData;
      });
    });
  }

  void addMessage(String message, bool isUser) {
    setState(() {
      chatMessages.add(ChatMessage(message, isUser));
    });
    _listViewController.animateTo(
      _listViewController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void handleUserMessage(String message) async {
    addMessage(message, true);

    if (chatMessages.length == 1) {
      addMessage(
        'Hi, I am the Kumari tourism chatbot. How can I assist you?',
        false,
      );
      addCategoryOptions();
    } else {
      if (selectedCategoryOptions.isEmpty) {
        if (selectCategoryOptions(message)) {
          addMessage(
            'Let\'s explore more! Please select a category.',
            false,
          );
        } else {
          await handleOpenAiResponse(message);
        }
      } else if (selectedPlace.name.isEmpty) {
        if (selectPlace(message)) {
        } else {
          await handleOpenAiResponse(message);
        }
      }
    }
  }

  Future<void> handleOpenAiResponse(String message) async {
    final response = await openAiApi.getResponse(message);
    addMessage(response, false);
  }

  bool selectCategoryOptions(String message) {
    for (var category in _tourismData.tourismData) {
      if (category.name.toLowerCase() == message.toLowerCase()) {
        selectedCategoryOptions = List.from(category.options);
        addMessage('You selected: ${category.name}', true);
        addMessage('Places in this category:', false);

        for (var place in selectedCategoryOptions) {
          addMessage('${place.name}', false);
        }

        addMessage(
          'To view the details of a place, type its name.',
          false,
        );
        return true;
      }
    }
    return false;
  }

  bool selectPlace(String message) {
    for (var place in selectedCategoryOptions) {
      if (message.toLowerCase().contains(place.name.toLowerCase())) {
        selectedPlace = place;
        addMessage('You selected: ${place.name}', true);
        addMessage('Here are the details about ${place.name}:', false);
        addMessage(' ${place.location}', false);
        addMessage(' ${place.food}', false);
        addMessage(' ${place.details}', false);

        selectedPlace = TourismPlace('', '', '', '');

        return true;
      }
    }
    return false;
  }

  void addCategoryOptions() {
    for (var category in _tourismData.tourismData) {
      addMessage(category.name, false);
    }
    addMessage(
      'Please select a category from the list by tapping its name.',
      false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 102, 231),
        title: const Text('Kumari Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: ResponsivePadding.fromLTRB(context, 9, 0, 9, 0),
              child: ListView.builder(
                controller: _listViewController,
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  return GestureDetector(
                    onTap: () {
                      onTapMessage(message);
                    },
                    child: Align(
                      alignment: message.isUser
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Container(
                        margin:
                            ResponsiveMargin.fromLTRB(context, 10, 5, 10, 5),
                        padding:
                            ResponsivePadding.fromLTRB(context, 8, 8, 8, 8),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? const Color.fromARGB(255, 32, 102, 231)
                              : const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.message,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                            fontSize: TextSizeScaler.scaleTextSize(context, 13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: ResponsiveMargin.fromLTRB(context, 10, 3, 10, 10),
            padding: ResponsivePadding.fromLTRB(context, 7, 0, 7, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 32, 100, 231).withOpacity(0.1),
                  spreadRadius: 6,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (message) {
                      handleUserMessage(message);
                      _textController.clear();
                    },
                    decoration: const InputDecoration(
                      hintText: 'chat with me...',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                    style: GoogleFonts.roboto(
                      fontSize: TextSizeScaler.scaleTextSize(context, 17),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    size: IconSizeScaler.scaleIconSize(context, 24.0),
                    color: const Color.fromARGB(255, 32, 100, 231),
                  ),
                  onPressed: () {
                    String message = _textController.text;
                    if (message.isNotEmpty) {
                      handleUserMessage(message);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(),
    );
  }

  void _handleSubmitted(String message) {
    handleUserMessage(message);
  }

  void onTapMessage(ChatMessage message) {
    if (!message.isUser) {
      if (selectedCategoryOptions.isEmpty) {
        selectCategoryOptions(message.message);
      } else if (selectedPlace.name.isEmpty) {
        if (selectPlace(message.message)) {
        } else {
          selectCategoryOptions(message.message);
        }
      }
    }
  }
}

class TourismData {
  final List<TourismCategory> tourismData;

  TourismData(this.tourismData);

  factory TourismData.fromJson(Map<String, dynamic> json) =>
      TourismData((json['tourismData'] as List<dynamic>)
          .map((e) => TourismCategory.fromJson(e as Map<String, dynamic>))
          .toList());
}

class TourismCategory {
  final String name;
  final List<TourismPlace> options;

  TourismCategory(this.name, this.options);

  factory TourismCategory.fromJson(Map<String, dynamic> json) =>
      TourismCategory(
        json['name'] as String,
        (json['options'] as List<dynamic>)
            .map((e) => TourismPlace.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class TourismPlace {
  final String name;
  final String location;
  final String food;
  final String details;

  TourismPlace(this.name, this.location, this.food, this.details);

  factory TourismPlace.fromJson(Map<String, dynamic> json) => TourismPlace(
        json['name'] as String,
        json['location'] as String,
        json['food'] as String,
        json['details'] as String,
      );
}

Future<TourismData> loadTourismData() async {
  final String data = await rootBundle.loadString('assets/datas.json');
  final jsonData = json.decode(data);
  return TourismData.fromJson(jsonData);
}
