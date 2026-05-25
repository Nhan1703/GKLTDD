import '../../domain/entities/login_result_entity.dart';

class LoginResponseModel {
  const LoginResponseModel({required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(token: json['token'] as String? ?? '');
  }

  LoginResultEntity toEntity() => LoginResultEntity(token: token);

  final String token;
}
