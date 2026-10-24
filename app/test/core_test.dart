import 'package:flutter_test/flutter_test.dart';
import 'package:shopbandit/core/invite_link.dart';
import 'package:shopbandit/core/items.dart';
import 'package:shopbandit/core/password_rules.dart';

void main() {
  group('password rules', () {
    test('valid password', () => expect(passwordProblems('Abcdef1!'), isEmpty));
    test('reports every missing rule', () {
      expect(passwordProblems('abc'), {
        PasswordRule.minLength,
        PasswordRule.uppercase,
        PasswordRule.digit,
        PasswordRule.special,
      });
      expect(passwordProblems('ABCDEFG1!'), {PasswordRule.lowercase});
      expect(passwordProblems('Abcdefgh!'), {PasswordRule.digit});
      expect(passwordProblems('Abcdefg12'), {PasswordRule.special});
    });
    test('umlaut and space count as special characters', () {
      expect(isValidPassword('Abcdefg1ü'), isTrue);
      expect(isValidPassword('Abcdefg1 '), isTrue);
    });
  });

  group('item names', () {
    test('clean keeps case, collapses spaces', () => expect(cleanItemName('  Rote   Paprika '), 'Rote Paprika'));
    test('normalize ignores case and spaces', () {
      expect(normalizeItemName(' MILCH '), normalizeItemName('milch'));
      expect(normalizeItemName('Äpfel  grün'), 'äpfel grün');
    });
    test('catalog id is deterministic per household', () {
      final a = catalogItemId('h1', 'milch');
      expect(a, catalogItemId('h1', 'milch'));
      expect(a, isNot(catalogItemId('h2', 'milch')));
      expect(a, matches(RegExp(r'^[a-z0-9]{15}$')));
    });
    test('random record ids', () {
      final ids = List.generate(200, (_) => newRecordId()).toSet();
      expect(ids.length, 200);
      expect(ids.every((i) => RegExp(r'^[a-z0-9]{15}$').hasMatch(i)), isTrue);
    });
  });

  group('frequency score', () {
    final now = DateTime(2026, 10, 24);
    test('never bought scores 0', () => expect(frequencyScore(0, now, now), 0));
    test('recent purchases weigh more', () {
      final recent = frequencyScore(5, now.subtract(const Duration(days: 2)), now);
      final old = frequencyScore(5, now.subtract(const Duration(days: 90)), now);
      expect(recent, greaterThan(old));
    });
    test('30 days ago counts half', () {
      expect(frequencyScore(4, now.subtract(const Duration(days: 30)), now), closeTo(2, 0.001));
    });
    test('many old purchases can beat one new', () {
      expect(
        frequencyScore(20, now.subtract(const Duration(days: 60)), now),
        greaterThan(frequencyScore(1, now, now)),
      );
    });
  });

  group('invite links', () {
    const token = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    test('round trip', () {
      final p = parseInvite(buildInviteLink('https://shop.example.com', token))!;
      expect(p.server, 'https://shop.example.com');
      expect(p.token, token);
    });
    test('manual entry with dashes and lower case', () {
      expect(parseInvite('abcd-efgh-jklm-npqr-stuv-wxyz')!.token, token);
      expect(parseInvite('abcd-efgh-jklm-npqr-stuv-wxyz')!.server, isNull);
    });
    test('garbage', () {
      expect(parseInvite('hello'), isNull);
      expect(parseInvite('https://evil.example.com/?token=$token'), isNull);
    });
  });
}
