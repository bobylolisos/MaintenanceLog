import 'package:maintenance_log/models/meter_type.dart';

extension MeterTypeExtensions on MeterType {
  String get displayName {
    switch (this) {
      case MeterType.none:
        return 'Ingen mätare';
      case MeterType.odometer:
        return 'Vägmätare (km)';
      case MeterType.hourmeter:
        return 'Timräknare (timmar)';
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
    }
  }
}
