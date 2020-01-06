# swift_ids

Convert numeric IDs to human and web friendly string and back.

| integer | swift_id |
|---|--------|
| 0 | GX08 |
| 1 | HY9U |
| 2 | JA2Q |
| 5 | D9YU |
| 1000 | SF7B |
| 10000000 | GM1Y3Q |

## features of generated id

* easy to write down / spell over the phone because generated string uses:
  * only uppercase letters,
  * no confusing digits: O=0 and I=L=1
  * no two consecutive characters are the same
* fast to convert back and forth (algorithm uses mostly binary operations)
* seems random (user can't browse trough entities easily or tell how many entities there are)
* generated id is shorter than original int as decimal (5 characters can save 8388608 ids)
* free from accidental profanities (and words in general)
* minimum length and initial zero code is configurable

## usage
```dart
var encode = new Id(5);
print("${encode.value} == ${encode.toString()}"); //5 == D9YU
var decode = new Id.fromString('D9YU');
print("${decode.value} == ${decode.toString()}"); //4 == C84X

var encode2 = new Id(5, minLength:10, zero:0x55555555555);
print("${encode2.value} == ${encode2.toString()}"); //5 == HBQ8H7E85B
//same zero/minLength need to be used when decoding
var decode2 = new Id.fromString('HBQ8H7E85B', minLength:10, zero:0x55555555555);
print("${decode2.value} == ${decode2.toString()}"); //4 == C84X
```

`zero` is an initial value that is XORed with input that can be used to:
* make separate entities ids not overlap (so user with id=5 won't have same hash as message with id=5)
* mangle initial integer to prevent repetitions for small integers with large `minLength`
* `zero` should have maximum `(5 * minLength) - (2 * (minLength / 3))` bits.
