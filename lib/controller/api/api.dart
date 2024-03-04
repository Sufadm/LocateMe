import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:locate_me/model/model.dart';
import 'package:dio/dio.dart';

final userDataProvider = FutureProvider<List<UserModel>>((ref) async {
  try {
    final dio = Dio();
    final Response response =
        await dio.get("https://reqres.in/api/users?page=1");
    if (response.statusCode == 200) {
      List<UserModel> userList =
          List<Map<String, dynamic>>.from(response.data['data'])
              .map((userData) => UserModel.fromJson(userData))
              .toList();
      return userList;
    } else {
      throw Exception("Request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
});
