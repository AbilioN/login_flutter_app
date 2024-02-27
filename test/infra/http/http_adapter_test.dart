import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class HttpAdapter {
  final Client client;

  HttpAdapter(this.client);

  Future<void> request({
    required String url,
    required String method,
  }) async {
    final uri = Uri.parse(url);
    await client.post(uri);
  }
}

@GenerateMocks([Client])
void main() {
  group('post', () {
    test('Should call post with correct values ', () async {
      final client = MockClient((request) async {
        return Response('...', 200);
      });
      final sut = HttpAdapter(client);
    });
  });
}
