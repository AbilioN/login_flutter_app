// import 'dart:io';
import 'package:main_app/domain/entities/account_entity.dart';
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
    final accessToken = faker.guid.guid();
    final name = faker.person.name();
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'accessToken': accessToken,
              'name': name,
            });
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

  test('Should throw UnexpectedError if MyHttpClient returns 500', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if MyHttpClient returns 401',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if MyHttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    final name = faker.person.name();
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'accessToken': accessToken,
              'name': name,
            });
    // act
    final account = sut.auth(params);
    // assert

    await expectLater(account, completion(isA<AccountEntity>()));
    final accountObject = await account;
    expect(accountObject.token, accessToken);
  });

  test(
      'Should throw an UnexpectedError if MyHttpClient returns 200 with invalid data',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async => {
              'invalid_key': 'invalid_value',
            });
    // act
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
