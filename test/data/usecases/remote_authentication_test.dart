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
  late RemoteAuthentication sut;
  late MockMyHttpClient httpClient;
  late String url;
  late AuthenticationParams params;

  setUp(() {
    httpClient = MockMyHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
  });

  test('Should call Http Client with correct correct values', () async {
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
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if MyHttpClient returns 400', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.unexpected));
  });
}
