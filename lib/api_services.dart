import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/learning_model.dart';  // Make sure this import matches where you put your model

class ApiService {
  static const String apiUrl = 'https://pinghr.in/api/get-learning';

  Future<List<LearningData>> fetchLearningData() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the data
      var jsonResponse = json.decode(response.body);
      return LearningResponse.fromJson(jsonResponse).data;
    } else {
      throw Exception('Failed to load learning data');
    }
  }
}
