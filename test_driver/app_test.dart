import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Testing App', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('Home Page check', () async {
      await driver.waitUntilFirstFrameRasterized();
      print('Waiting for Now Playing to be loaded...');
      expect(driver.waitFor(find.byValueKey('nowpl_movies_lv')), completes);
      print('Opening Detail Page');
      await driver.waitFor(find.byValueKey('nowpl_movies_item_1'));
      await driver.tap(find.byValueKey('nowpl_movies_item_1'));
      print('Testing Watchlist Button');
      await driver.waitFor(find.byValueKey('watchlist_btn'));
      await driver.tap(find.byValueKey('watchlist_btn'));
      print('Checking recommendations');
      expect(driver.waitFor(find.byValueKey('recommendations_lv')), completes);
      await driver.scrollIntoView(find.byValueKey('recommendations_lv'));
      print('Going back..');
      await driver.tap(find.byValueKey('back_button'));
      print('Checking See more..');
      await driver.waitFor(find.byValueKey('popular_movies_more'));
      await driver.tap(find.byValueKey('popular_movies_more'));
      expect(driver.waitFor(find.byValueKey('popular_movies_lv')), completes);
      print('Going back..');
      await driver.tap(find.byValueKey('back_button'));
      print('OK its done!');
    });

    test('TV Page check', () async {
      await driver.waitFor(find.text('TV Shows'));
      await driver.tap(find.text('TV Shows'));
      print('Waiting for On The Air to be loaded...');
      expect(driver.waitFor(find.byValueKey('ota_tv_lv')), completes);
      print('Opening Detail Page');
      await driver.waitFor(find.byValueKey('ota_tv_item_1'));
      await driver.tap(find.byValueKey('ota_tv_item_1'));
      print('Testing Watchlist Button');
      await driver.waitFor(find.byValueKey('watchlist_btn'));
      await driver.tap(find.byValueKey('watchlist_btn'));
      print('Checking recommendations');
      expect(driver.waitFor(find.byValueKey('recommendations_lv')), completes);
      await driver.scrollIntoView(find.byValueKey('recommendations_lv'));
      print('Going back..');
      await driver.tap(find.byValueKey('back_button'));
      print('Checking See more..');
      await driver.waitFor(find.byValueKey('ota_tv_more'));
      await driver.tap(find.byValueKey('ota_tv_more'));
      expect(driver.waitFor(find.byValueKey('ota_tv_lv')), completes);
      print('Going back..');
      await driver.tap(find.byValueKey('back_button'));
      print('OK its done!');
    });

    test('Watchlist Page check', () async {
      final drawerFinder = find.byTooltip('Open navigation menu');
      await driver.waitFor(drawerFinder);
      await driver.tap(drawerFinder);
      await driver.waitFor(find.byValueKey('watchlist_tile'));
      await driver.tap(find.byValueKey('watchlist_tile'));
      print('Going back..');
      await driver.tap(find.byValueKey('back_button'));
      print('OK its done!');
    });
  });
}
