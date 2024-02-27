import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapter {
  final http.Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
    Map? body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    // await client.post(uri, headers: headers, body: jsonEncode(body));
    // await client.post(uri, headers: headers, body: body);

    await client.post(uri, headers: headers);
  }
}

class ClientSpy extends Mock implements http.Client {}

@GenerateMocks([ClientSpy])
void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;
  // late Uri url;

  setUp(() {
    client = MockClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group('post', () {
    test('Should call post with correct values ', () async {
      final testUrl = Uri.parse(url);
      when(client.post(
        testUrl,
        headers: anyNamed('headers'),
        // body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('...', 200));

      await sut.request(
        url: url,
        method: 'post',
        // body: {'any_key': 'any_value'},
      );
      verify(client.post(
        Uri.parse(url),
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json',
        },
        // body: "{'any_key': 'any_value'}",
      ));

      // verify(client.post(testUrl)).called(matcher)
    });
  });
}
