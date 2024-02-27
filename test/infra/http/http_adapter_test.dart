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
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };
    final uri = Uri.parse(url);
    await client.post(uri, headers: headers);
  }
}

class ClientSpy extends Mock implements http.Client {}

@GenerateMocks([ClientSpy])
void main() {
  late HttpAdapter sut;
  late ClientSpy client;
  late String url;

  setUp(() {
    client = MockClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group('post', () {
    test('Should call post with correct values ', () async {
      // final client = MockClientSpy();
      // final sut = HttpAdapter(client);
      // final url = faker.internet.httpUrl();
      when(client.post(Uri.parse(url), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('...', 200));

      sut.request(url: url, method: 'post');
      verify(client.post(Uri.parse(url), headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      })).called(1);
    });
  });
}
