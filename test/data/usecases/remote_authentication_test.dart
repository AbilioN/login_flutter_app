// import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';

import 'package:main_app/data/http/http.dart';
import 'package:main_app/data/usecases/usecases.dart';

import 'package:main_app/domain/helpers/helpers.dart';
import 'package:main_app/domain/usecases/usecases.dart';
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
    const method = 'post';
    // act
    await sut.auth(params);
    // assert
    verify(httpClient.request(
        url: url,
        method: method,
        body: {'email': params.email, 'password': params.password}));
  });

  test('Should throw UnexpectedError if MyHttpClient returns 400', () async {
    httpClient = MockMyHttpClient();

    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);

    final params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    const method = 'post';
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.unexpected));
  });
}
