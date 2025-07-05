import 'package:employeeattendance/models/holiday.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/learning_model.dart';  // Make sure this import matches where you put your model
import 'model/salary_structure_model.dart';

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

    Future<List<Holiday>> fetchHolidays() async {
    final response = await http.get(Uri.parse('https://pinghr.in/api/get-holiday'));

    if (response.statusCode == 200||response.statusCode==201) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Holiday.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load holidays');
    }
  }

  Future<List<Map<String, dynamic>>> fetchLeaveData(String empId) async {
    final response = await http.post(Uri.parse('https://pinghr.in/api/leavedata?emp_id=$empId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        return List<Map<String, dynamic>>.from(data['Employee Leave Data']);
      } else {
        throw Exception('Failed to load leave data');
      }
    } else {
      throw Exception('Failed to load leave data');
    }
  }

  Future<SalaryStructureResponse> fetchSalaryStructure(String empId, String salaryMonth) async {
    final response = await http.get(
      Uri.parse('https://pinghr.in/api/salary-structure-employee?emp_id=$empId&salary_month=$salaryMonth'),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return SalaryStructureResponse.fromJson(data);
    } else {
      throw Exception('Failed to load salary structure data');
    }
  }
}
