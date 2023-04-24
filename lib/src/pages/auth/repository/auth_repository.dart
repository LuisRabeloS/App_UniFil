import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:loja/src/config/app_data.dart';
import 'package:loja/src/models/user_model.dart';
import 'package:loja/src/pages/auth/repository/auth_errors.dart' as authErrors;
import 'package:loja/src/pages/auth/result/auth_result.dart';
import 'package:loja/src/services/http_manager.dart';

import '../../../constants/endpoints.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();
  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
      print(user);
    } else {
      //authErrorsString(code)
      return AuthResult.error(authErrors.authErrorsString(result['error']));
    }
  }

  Future<bool> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.changePassword,
        method: HttpMethods.post,
        body: {
          'email': email,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        headers: {
          'X-Parse-Session-Token': token,
        });
    return result['error'] == null;
  }

  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.validateToken,
        method: HttpMethods.post,
        headers: {
          'X-Parse-Session-Token': token,
        });
    return handleUserOrError(result);
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager
        .restRequest(url: Endpoints.signIn, method: HttpMethods.post, body: {
      "email": email,
      "password": password,
    });
    return handleUserOrError(result);
  }

  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signUp, method: HttpMethods.post, body: user.toJson());
    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
      url: Endpoints.resetPassword,
      method: HttpMethods.post,
      body: {'email': email},
    );
  }
}
