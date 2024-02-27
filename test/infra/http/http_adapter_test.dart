import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:main_app/data/http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter implements MyHttpClient {
  final http.Client client;

  HttpAdapter(this.client);

  Future<Map<dynamic, dynamic>> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    final jsonBody = body != null ? jsonEncode(body) : null;
    final response = await client.post(uri, headers: headers, body: jsonBody);
    return response.body.isEmpty ? {} : jsonDecode(response.body);
  }
}

class ClientSpy extends Mock implements http.Client {}

@GenerateMocks([ClientSpy])
void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;
  late Map testBody;
  // late Uri url;

  setUp(() {
    client = MockClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
    testBody = {'any_key': 'any_value'};
  });
  group('post', () {
    test('Should call post with correct values ', () async {
      final testUrl = Uri.parse(url);
      when(client.post(
        testUrl,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      await sut.request(
        url: url,
        method: 'post',
        body: testBody,
      );
      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        // body: jsonEncode(testBody),
        body: '{"any_key":"any_value"}',
      )).called(1);

      // verify(client.post(testUrl)).called(matcher)
    });

    test('Should call post with correct values without body', () async {
      final testUrl = Uri.parse(url);
      when(client.post(
        testUrl,
        headers: anyNamed('headers'),
        // body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      await sut.request(
        url: url,
        method: 'post',
        // body: testBody,
      );
      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        // body: jsonEncode(testBody),
      )).called(1);

      // verify(client.post(testUrl)).called(matcher)
    });

    test('Should return data if post returns 200', () async {
      final testUrl = Uri.parse(url);
      when(client.post(
        testUrl,
        headers: anyNamed('headers'),
        // body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('{"any_key":"any_value"}', 200));

      final response = await sut.request(
        url: url,
        method: 'post',
        // body: testBody,
      );

      expect(response, {'any_key': 'any_value'});

      // verify(client.post(testUrl)).called(matcher)
    });

    test('Should return empty object if post returns 200 with no data',
        () async {
      final testUrl = Uri.parse(url);
      when(client.post(
        testUrl,
        headers: anyNamed('headers'),
        // body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 200));

      final response = await sut.request(
        url: url,
        method: 'post',
        // body: testBody,
      );

      expect(response, {});

      // verify(client.post(testUrl)).called(matcher)
    });
  });
}
