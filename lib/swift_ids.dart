library swift_ids;

final String _encodeChars = '0123456789QVXYABCDEFGHJKMNPRSTWZU';

final Map<String, int> _decodeMap = const {
  '0': 0,
  '1': 1,
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  'Q': 10,
  'V': 11,
  'X': 12,
  'Y': 13,
  'A': 14,
  'B': 15,
  'C': 16,
  'D': 17,
  'E': 18,
  'F': 19,
  'G': 20,
  'H': 21,
  'J': 22,
  'K': 23,
  'M': 24,
  'N': 25,
  'P': 26,
  'R': 27,
  'S': 28,
  'T': 29,
  'W': 30,
  'Z': 31,
  'U': 32
};

final Map<String, String> _typosMap = const {'O': '0', 'I': '1', 'L': '1'};

/// Exception thrown when there is a typo possible in user input.
/// When ID is used in URL, allows to redirect to propel URL.
class PossibleTypoException implements Exception {
  String candidate;
  PossibleTypoException(this.candidate);
}

/// Convenient int to String converter with common settings
class IdConverter {
  final int minLength;
  final int zero;
  IdConverter({this.minLength = 4, this.zero = 0x11111});

  String encode(int value) {
    return new Id(value, minLength: this.minLength, zero: this.zero).toString();
  }

  int decode(String value) {
    return Id.fromString(value, minLength: this.minLength, zero: this.zero)
        .value;
  }
}

/// Human friendly hash string
class Id {
  int value;
  final int minLength;
  final int zero;

  /// create from integer value. Use to encode int
  Id(this.value, {this.minLength = 4, this.zero = 0x11111});

  /// create from string value. Use to decode hash.
  Id.fromString(String string, {this.minLength = 4, this.zero = 0x11111})
      : value = 0 {
    value = _decode(string);
  }

  void _checkForPossibleTypo(String string) {
    var candidate = '';
    string.split('').forEach((String char) {
      if (_decodeMap.containsKey(char)) {
        candidate += char;
      } else if (_typosMap.containsKey(char)) {
        candidate += _typosMap[char]!;
      } else {
        return;
      }
    });
    //if (_decode(string))
    throw PossibleTypoException(candidate);
  }

  int _decode(String string) {
    var value = 0;
    var chars = 0;
    var prevDecoded = 0;
    var offset = 0;
    var mangler = 0x5;
    string.split('').forEach((String char) {
      if (!_decodeMap.containsKey(char)) {
        _checkForPossibleTypo(string);
        throw Exception('unknow character: ' + char);
      }
      var decoded = _decodeMap[char]!;
      if (decoded == 32) {
        decoded = prevDecoded;
      }
      if (chars++ == 2) {
        if (decoded & 16 > 0) {
          throw Exception('checksum error');
        }
        if ((decoded & 0x7 < 6) && (decoded >> 3) != (prevDecoded & 1)) {
          throw Exception('checksum error');
        }
        value = value + (((decoded & 0x7) ^ mangler) << offset);
        mangler = decoded & 0x7;
        offset += 3;
        chars = 0;
      } else {
        value = value + ((decoded ^ mangler) << offset);
        mangler = decoded & 0x7;
        offset += 5;
      }
      prevDecoded = _decodeMap[char]!;
    });
    return value ^ zero;
  }

  String _encode(int value) {
    value = value ^ zero;

    var ret = '';
    var mangler = 0x5;
    var prevCharCode = 0;
    var charCode = 0;
    var chars = 0;
    while (value > 0 || ret.length < minLength) {
      if (chars++ == 2) {
        charCode = (value & 7) ^ mangler;
        value >>= 3;
        if (charCode < 6) {
          //checksum
          charCode += (prevCharCode & 1) << 3;
        }
        chars = 0;
      } else {
        charCode = (value & 31) ^ mangler;
        value >>= 5;
      }
      mangler = charCode & 0x7;
      if (charCode == prevCharCode) {
        charCode = 32;
      }
      prevCharCode = charCode;
      ret += _encodeChars[charCode];
    }
    return ret;
  }

  ///return hash representation
  @override
  String toString() {
    return _encode(value);
  }

  @override
  operator ==(o) => o is Id && o.value == value;

  @override
  int get hashCode => value.hashCode;
}
