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

  Map mockValidData() => {
        'accessToken': faker.guid.guid(),
        'name': faker.person.name(),
      };

  PostExpectation<Future<Map<dynamic, dynamic>>> mockRequest() =>
      when(httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
          body: anyNamed('body')));

  void mockHttpData(Map data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = MockMyHttpClient();
    url = faker.internet.httpUrl();
    sut = RemoteAuthentication(httpClient: httpClient, url: url);
    params = AuthenticationParams(
      email: faker.internet.email(),
      password: faker.internet.password(),
    );
    mockHttpData(mockValidData());
  });

  test('Should call Http Client with correct correct values', () async {
    const method = 'post';
    await sut.auth(params);
    // assert
    verify(httpClient.request(
        url: url,
        method: method,
        body: {'email': params.email, 'password': params.password}));
  });

  test('Should throw UnexpectedError if MyHttpClient returns 400', () async {
    mockHttpError(HttpError.badRequest);
    // act
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if MyHttpClient returns 400', () async {
    mockHttpError(HttpError.notFound);
    // act
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if MyHttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);
    // act
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if MyHttpClient returns 401',
      () async {
    mockHttpError(HttpError.unauthorized);
    // act
    final future = sut.auth(params);
    // assert

    expect(future, throwsA(DomainError.invalidCredentials));
  });

  test('Should return an Account if MyHttpClient returns 200', () async {
    final validData = mockValidData();
    mockHttpData(validData);
    // mockHttpError(HttpError.unauthorized);

    // act
    final account = sut.auth(params);
    // assert

    await expectLater(account, completion(isA<AccountEntity>()));
    final accountObject = await account;
    expect(accountObject.token, validData['accessToken']);
  });

  test(
      'Should throw an UnexpectedError if MyHttpClient returns 200 with invalid data',
      () async {
    mockHttpData({
      'invalid_key': 'invalid_value',
    });
    // act
    final future = sut.auth(params);
    // assert
    expect(future, throwsA(DomainError.unexpected));
  });
}
