import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAiApi {
  static const String baseUrl = 'https://api.openai.com/v1';
  static const String apiKey = 'sk-proj-O94C1d3XzWuR3sFNPge1T3BlbkFJa7HzSw8XZqfSsg038N48'; // Replace with your OpenAI API key

  Future<String> getResponse(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode({
          'model': 'text-davinci-002',
          'prompt': message,
          'max_tokens': 150,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['text'].toString();
      } else {
        print('Failed to get response: ${response.statusCode}');
        return 'Sorry, I couldn\'t fetch a response at the moment.';
      }
    } catch (e) {
      print('Error: $e');
      return 'Sorry, an error occurred while fetching the response.';
    }
  }
}
