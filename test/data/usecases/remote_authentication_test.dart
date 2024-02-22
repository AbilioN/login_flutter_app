// import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';

import 'package:main_app/data/http/http.dart';
import 'package:main_app/data/usecases/usecases.dart';
import 'package:main_app/domain/usecases/usecases.dart';
import 'package:mockito/annotations.dart';
// import 'package:flutter/material.dart';

import 'remote_authentication_test.mocks.dart';

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
