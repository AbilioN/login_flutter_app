import 'package:main_app/data/models/models.dart';
import 'package:main_app/domain/entities/entities.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final MyHttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final response =
          await httpClient.request(url: url, method: 'post', body: body);
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      // throw DomainError.unexpected;
      throw error == HttpError.unauthorized
          ? DomainError.invalidCredentials
          : DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(
          email: entity.email, password: entity.password);

  Map toJson() => {'email': email, 'password': password};
}
