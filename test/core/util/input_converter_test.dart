import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kada_ngalih/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'shoud return an integer when the string represent as unsigned integer',
      () async {
        final str = '123';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Right(123));
      },
    );

    test(
      'should return a Failure when the string is not an integer',
      () {
        final str = 'abc';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a Failure when the string is a negative integer',
      () {
        final str = '-123';

        final result = inputConverter.stringToUnsignedInteger(str);

        expect(result, Left(InvalidInputFailure()));
      },
    );
  });

  group('stringToDouble', () {
    test(
      'shoud return an double',
      () async {
        final str = '-3.3232';

        final result = inputConverter.stringToDouble(str);

        expect(result, Right(-3.3232));
      },
    );

    test(
      'should return a Failure when the string is not an double',
      () {
        final str = 'abc';

        final result = inputConverter.stringToDouble(str);

        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
