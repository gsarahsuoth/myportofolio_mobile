import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myportofolio_mobile/main.dart';
import 'package:myportofolio_mobile/services/api_client.dart';

void main() {
  testWidgets('MyApp renders home screen smoke test', (
    WidgetTester tester,
  ) async {
    final mockClient = MockClient((request) async {
      return http.Response('[]', 200);
    });

    final apiClient = ApiClient(
      client: mockClient,
      baseUrl: 'http://localhost:8000',
    );

    await tester.pumpWidget(MyApp(apiClient: apiClient));
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
