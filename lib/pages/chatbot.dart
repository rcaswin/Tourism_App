import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateFormat _dateFormat = DateFormat('d MMMM yyyy');

  List<ChatResponse> _chatResponses = [];
  final ChatHistory _chatHistory = ChatHistory();

  @override
  void initState() {
    super.initState();
    _loadChatbotResponses();
    _loadChatHistory();
  }

  void _loadChatbotResponses() async {
    final data = await rootBundle.loadString('assets/data.json');
    final responseList = json.decode(data)['responses'];

    for (final response in responseList) {
      final chatResponse = ChatResponse(
        keywords: List<String>.from(response['keywords']),
        response: response['response'],
      );
      _chatResponses.add(chatResponse);
    }
  }

  void _loadChatHistory() async {
    final chatData = await _chatHistory.loadChatHistory();
    setState(() {
      _messages.addAll(chatData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isDayChanged = _isDayChanged(message);
                return Column(
                  children: [
                    if (isDayChanged) _buildDateText(message.timestamp),
                    ChatMessage(message: message),
                  ],
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(10),
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
            child: _buildChatInput(),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
                style: GoogleFonts.imprima(
                  fontSize: 17,
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                size: 25,
                color: Color.fromARGB(255, 32, 100, 231),
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      _textController.clear();
      final now = DateTime.now();
      final message = Message(
        type: "user",
        message: text,
        timestamp: now,
      );
      _saveMessageToHistory(message);
      setState(() {
        _messages.add(message);
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      _handleBotResponse(text);
    }
  }

  void _saveMessageToHistory(Message message) {
    _chatHistory.saveChatHistory(_messages);
  }

  void _handleBotResponse(String userMessage) async {
    String botResponse = "I don't understand. Ask a different question.";

    // Check local data for responses
    for (final response in _chatResponses) {
      if (response.keywords.any((keyword) =>
          userMessage.toLowerCase().contains(keyword.toLowerCase()))) {
        botResponse = response.response;
        break;
      }
    }

    if (botResponse == "I don't understand. Ask a different question.") {
      // Query OpenAI for response
      final openAIResponse = await _fetchOpenAIResponse(userMessage);
      if (openAIResponse != null) {
        botResponse = openAIResponse;
      }
    }

    final responseMessage = Message(
      type: "bot",
      message: botResponse,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(responseMessage);
    });

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Save the message to chat history
    _saveMessageToHistory(responseMessage);
  }

  Future<String?> _fetchOpenAIResponse(String prompt) async {
    const apiKey = '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'; // Replace with your OpenAI API key
    const openAiEndpoint = 'https://api.openai.com/v1/engines/davinci/completions';

    try {
      final response = await http.post(
        Uri.parse(openAiEndpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'prompt': prompt, 'max_tokens': 150}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['choices'][0]['text'];
      } else {
        print('Failed to fetch response from OpenAI: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching response from OpenAI: $e');
      return null;
    }
  }

  Widget _buildDateText(DateTime timestamp) {
    final formattedDate = _dateFormat.format(timestamp);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Color.fromARGB(255, 73, 73, 73),
          fontSize: 13,
        ),
      ),
    );
  }

  bool _isDayChanged(Message message) {
    final messageIndex = _messages.indexOf(message);
    if (messageIndex > 0) {
      final previousMessage = _messages[messageIndex - 1];
      return !isSameDay(message.timestamp, previousMessage.timestamp);
    }
    return true;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;

  ChatMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final isBotMessage = message.type == "bot";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment:
            isBotMessage ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isBotMessage
                    ? const Color.fromARGB(255, 32, 102, 231)
                    : const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                message.message,
                style: TextStyle(
                  color: isBotMessage ? Colors.white : Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String type;
  final String message;
  final DateTime timestamp;

  Message({
    required this.type,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      type: json['type'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class ChatResponse {
  final List<String> keywords;
  final String response;

  ChatResponse({
    required this.keywords,
    required this.response,
  });
}

class ChatHistory {
  Future<List<Message>> loadChatHistory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/chat_history.json');
      if (file.existsSync()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => Message.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading chat history: $e');
      return [];
    }
  }

  Future<void> saveChatHistory(List<Message> messages) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/chat_history.json');
      final List<dynamic> jsonList =
          messages.map((message) => message.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving chat history: $e');
    }
  }
}
