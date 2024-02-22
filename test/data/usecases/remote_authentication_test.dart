// import 'dart:io';

import 'dart:io';

import 'package:faker/faker.dart';
import 'package:main_app/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
// import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final MyHttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth(AuthenticationParams params) async {
    final body = {'email': params.email, 'password': params.password};
    await httpClient.request(url: url, method: 'post', body: body);
  }
}

abstract class MyHttpClient {
  Future<void> request({
    required String url,
    required String method,
    Map body,
  });
}

@GenerateMocks([MyHttpClient])
void main() {
  RemoteAuthentication sut;
  MockMyHttpClient httpClient;
  String url;

  // setUp(() {
  //   httpClient = MockMyHttpClient();
  //   url = faker.internet.httpUrl();
  //   sut = RemoteAuthentication(httpClient: httpClient, url: url);
  // });
  test('Should call Http Client with correct correct values', () async {
    httpClient = MockMyHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    // arranje
    const method = 'post';
    // act
    await sut.auth(params);
    // assert
    verify(httpClient.request(
        url: url,
        method: method,
        body: {'email': params.email, 'password': params.password}));
  });
}
