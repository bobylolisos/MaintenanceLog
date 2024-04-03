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
        return 'km';
      case MeterType.hourmeter:
        return 'timmar';
      case MeterType.dateMeter:
        return '';
    }
  }
}
