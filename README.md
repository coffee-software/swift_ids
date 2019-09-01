# swift_ids

Convert number IDs to human friendly string and back.

| integer | swift_id |
|---|--------|
| 0 | GX08 |
| 1 | HY9U |
| 2 | JA2Q |
| 5 | D9YU |
| 1000 | SF7B |
| 10000000 | GM1Y3Q |

The generated ID is:

* fast to convert back and forth (algorithm uses mostly binary operations)
* seems random (end user can't browse trough entities easily)
* user can't tell how many entities there are
* shorter than original int (5 characters can save 8388608 ids)
* easy to write down / spell over the phone because generated string uses:
  * only uppercase letters,
  * no confusing digits: O=0 and I=L=1
  * no two consecutive characters are the same
* avoid accidental profanities (and words in general)
* minimum length is configurable

## usage
```dart
var encode = new Id(5)
print("${encode.value} == ${encode.toString()}"); //5 == D9YU
var decode = new Id.fromString('D9YU');
print("${decode.value} == ${decode.toString()}"); //4 == C84X

//to configurable minimum lenght:
var encode = new Id(5, minLength:10, zero:0x55555555555)
print("${encode.value} == ${encode.toString()}"); //5 == HBQ8H7E85B
//same zero/minLength need to be used when decoding
```

`zero` is an initial value that is XORed with input that can be used to:
* make separate entities ids not overlap (so user with id=5 won't have same hash as message with id=5)
* mangle initial integer to prevent repetitions for small integers with large `minLength`
* `zero` should have maximum `(5 * minLength) - (2 * (minLength / 3))` bits.
