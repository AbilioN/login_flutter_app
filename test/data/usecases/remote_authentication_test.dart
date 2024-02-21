// import 'dart:io';

import 'package:faker/faker.dart';
import 'package:mockito/annotations.dart';
// import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'remote_authentication_test.mocks.dart';

class RemoteAuthentication {
  final MyHttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async {
    await httpClient.request(url: url, method: 'post');
  }
}

abstract class MyHttpClient {
  Future<void> request({required String url, required String method});
}

@GenerateMocks([MyHttpClient])
void main() {
  test('Should call Http Client with correct correct values', () async {
    // arranje

    final httpClient = MockMyHttpClient();
    final url = faker.internet.httpUrl();
    const method = 'post';
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    // assert
    verify(httpClient.request(url: url, method: method));
  });
}
