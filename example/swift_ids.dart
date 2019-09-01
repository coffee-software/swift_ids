#!/usr/bin/env dart

import 'package:swift_ids/swift_ids.dart';

void main (List<String> arguments) {
  var encode = new Id(5);
  print("${encode.value} == ${encode.toString()}"); //5 == D9YU
  var decode = new Id.fromString('D9YU');
  print("${decode.value} == ${decode.toString()}"); //4 == C84X

  var encode2 = new Id(5, minLength:10, zero:0x55555555555);
  print("${encode2.value} == ${encode2.toString()}"); //5 == HBQ8H7E85B
  //same zero/minLength need to be used when decoding
  var decode2 = new Id.fromString('HBQ8H7E85B', minLength:10, zero:0x55555555555);
  print("${decode2.value} == ${decode2.toString()}"); //4 == C84X
}
