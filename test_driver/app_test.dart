import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
 
void main() {
  group('Testing App', () {
    late FlutterDriver driver;
 
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
 
    test('Home Check', () async {
      
      await driver.waitUntilFirstFrameRasterized();
      expect(driver.waitFor(find.byValueKey('lv_item')), completes);
    });

    tearDownAll(() async {
      await driver.close();
    });
  });
}