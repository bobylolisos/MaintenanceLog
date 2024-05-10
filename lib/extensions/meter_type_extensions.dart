import 'package:basic_utils/basic_utils.dart';
import 'package:maintenance_log/models/meter_type.dart';

extension MeterTypeExtensions on MeterType {
  String get displayName {
    switch (this) {
      case MeterType.none:
        return 'Ingen mätare';
      case MeterType.odometer:
        return 'Sträcka (km)';
      case MeterType.hourmeter:
        return 'Tid (timmar)';
      case MeterType.dateMeter:
        return 'Datum';
    }
  }

  String get displaySuffix {
    switch (this) {
      case MeterType.none:
        return '';
      case MeterType.odometer:
        return 'mil';
      case MeterType.hourmeter:
        return 'timmar';
      case MeterType.dateMeter:
        return '';
    }
  }

  String toMeterValueString(int? value) {
    var str = value?.toString() ?? '';

    if (this == MeterType.odometer) {
      if (str.length < 5) {
        if (str.length >= 2) {
          return StringUtils.addCharAtPosition(str, ',', str.length - 1);
        } else {
          return '0,$str';
        }
      }

      var newStr = StringUtils.addCharAtPosition(str, ',', str.length - 1);
      return StringUtils.addCharAtPosition(newStr, '.', str.length - 4);
    }

    return str;
  }

  String toMeterValueStringWithSuffix(int? value) {
    var str = toMeterValueString(value);

    return '$str $displaySuffix';
  }
}
