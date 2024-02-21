// import 'dart:io';

import 'package:faker/faker.dart';
// import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class RemoteAuthentication {
  final MyHttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});
  Future<void> auth() async {
    await httpClient.request(url: url);
  }
}

abstract class MyHttpClient {
  Future<void> request({required String url});
}

class MyHttpClientSpy extends Mock implements MyHttpClient {}

void main() {
  test('Should call Http Client with correct URL', () async {
    // arranje
    final httpClient = MyHttpClientSpy();
    final url = faker.internet.httpUrl();
    final sut = RemoteAuthentication(httpClient: httpClient, url: url);

    // act
    await sut.auth();

    verify(httpClient.request(url: url));
    // assert
  });
}
