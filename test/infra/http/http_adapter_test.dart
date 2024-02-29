import 'package:faker/faker.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:main_app/data/http/http.dart';
import 'package:main_app/infra/http/http_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'http_adapter_test.mocks.dart';

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
    PostExpectation mockRequest() => when(client.post(Uri.parse(url),
        headers: anyNamed('headers'), body: anyNamed('body')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => http.Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values ', () async {
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
    });

    test('Should call post with correct values without body', () async {
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
      mockResponse(200, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
        // body: testBody,
      );

      expect(response, {});
    });

    test('Should return empty object if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(
        url: url,
        method: 'post',
        // body: testBody,
      );

      expect(response, {});
    });

    test('Should return BadRequestError  if post returns 400', () async {
      mockResponse(400);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return BadRequestError  if post returns 400 with invalid data',
        () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return UnauthorizedError  if post returns 401', () async {
      mockResponse(401);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return ForbiddenError  if post returns 403', () async {
      mockResponse(403);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.forbidden));
    });

    test('Should return NotFoundError  if post returns 404', () async {
      mockResponse(404);
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.notFound));
    });
    test('Should return ServerError  if post returns 500', () async {
      mockResponse(400, body: '');
      final future = sut.request(url: url, method: 'post');
      expect(future, throwsA(HttpError.badRequest));
    });
  });
}
