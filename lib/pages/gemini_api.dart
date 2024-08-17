import 'dart:convert';
import 'package:http/http.dart' as http;



class GeminiApi {
  static const String baseUrl = 'https://api.gemini.com/v1'; // Replace with the correct Gemini API base URL
  static const String apiKey = 'AIzaSyAy9vztYxEm65qRjraV1x9t5NEjehYlVQ8';

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
        print('Response body: ${response.body}');
        return 'Sorry, I couldn\'t fetch a response at the moment.';
      }
    } catch (e) {
      print('Error: $e');
      return 'Sorry, an error occurred while fetching the response.';
    }
  }
}
