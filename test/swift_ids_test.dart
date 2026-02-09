library swift_ids.test;

import 'package:test/test.dart';
import 'package:swift_ids/swift_ids.dart';
import 'package:hashids2/hashids2.dart';

void main() {
  test('integrity', () {
    for (int minLength = 1; minLength <= 5; minLength++) {
      for (int i = 0; i < 100; i++) {
        //String encoded = new Id(i, minLength: 3).toString();
        //print("$i => ${encoded} => ${new Id.fromString(encoded, minLength: 3).toInt()}");
        expect(
            new Id.fromString(new Id(i, minLength: minLength).toString(),
                    minLength: minLength)
                .value,
            equals(i));
      }
      //large numbers
      for (int i = 4503599627370456; i < 4503599627370496; i++) {
        expect(
            new Id.fromString(new Id(i, minLength: minLength).toString(),
                    minLength: minLength)
                .value,
            equals(i));
      }
    }
  });

  test('values', () {
    expect(new Id(0).toString(), equals('GX08'));
    expect(new Id(1).toString(), equals('HY9U'));
    expect(new Id(2).toString(), equals('JA2Q'));
    expect(new Id(3).toString(), equals('KBVU'));
    expect(new Id(4).toString(), equals('C84X'));
    expect(new Id(5).toString(), equals('D9YU'));
    expect(new Id(10).toString(), equals('WA2Q'));
    expect(new Id(100).toString(), equals('CV7B'));
    expect(new Id(1000).toString(), equals('SF7B'));
    expect(new Id(10000000).toString(), equals('GM1Y3Q'));
    expect(new Id(5, minLength: 10, zero: 0x55555555555).toString(),
        equals('HBQ8H7E85B'));
  });

  test('benchmark', () {
    //int start = new DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 100000; i++) {
      expect(new Id.fromString(new Id(i).toString()).value, equals(i));
    }
    //int start2 = new DateTime.now().millisecondsSinceEpoch;
    //print(start2 - start);
    final hashids = HashIds();
    for (int i = 0; i < 100000; i++) {
      expect(hashids.decode(hashids.encode(i))[0], equals(i));
      //print("$i => ${fromNumber} => ${number}");
    }
    //print(new DateTime.now().millisecondsSinceEpoch - start2);
  });

  test('typos', () {
    expect(() => new Id.fromString('AOL'),
        throwsA(TypeMatcher<PossibleTypoException>()));
  });

  test('identity', () {
    var a = new Id(5);
    var b = new Id(5);
    var c = new Id(6);
    expect(a, equals(b));
    expect(a, isNot(c));
    Map<Id, int> map = {};
    map[a] = 0;
    expect(map[b], equals(0));
    map[b] = 0;
    map[c] = 0;
    expect(map.length, equals(2));
  });

  test('converter', () {
    var converter = new IdConverter(minLength: 9, zero: 0x1234512345);
    var expectedValues = {
      0: 'UP2VK7Q67',
      1: '1RVQJ6V76',
      2: '2M09HY845',
      100: '4TYXC0Y18',
      101: '5S4YD9X01',
      102: '6Z7AE2B3Q',
    };
    expectedValues.forEach((value, expected) {
      expect(converter.encode(value), equals(expected));
      expect(converter.encode(value),
          equals(new Id(value, minLength: 9, zero: 0x1234512345).toString()));
    });
  });
}
