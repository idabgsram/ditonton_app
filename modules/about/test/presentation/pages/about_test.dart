import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:about/about.dart';

class FakeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListTile(
      key: Key('fake_tile'),
      onTap: () {
        Navigator.pushNamed(context, '/second');
      },
      title: Text('This is FaAke'),
      leading: Icon(Icons.check),
    ));
  }
}

void main() {
  final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => FakeHomePage(),
    '/second': (BuildContext context) => AboutPage(),
  };
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Page should render and go back when back tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(routes: routes));
    expect(find.byKey(Key('fake_tile')), findsOneWidget);

    await tester.tap(find.byKey(Key('fake_tile')));

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));

    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    expect(find.byKey(Key('fake_tile')), findsNothing);

    await tester.tap(find.byType(IconButton));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(imageFinder, findsNothing);
  });
}
