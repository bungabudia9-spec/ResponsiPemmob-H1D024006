class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitation;
  final double windSpeed;
  final int weatherCode;

  CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemperature;
  final double minTemperature;
  final int precipitationProbabilityMax;
  final int weatherCode;

  DailyForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.precipitationProbabilityMax,
    required this.weatherCode,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json, int index) {
    final times = json['time'] as List<dynamic>? ?? [];
    final maxTemps = json['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = json['temperature_2m_min'] as List<dynamic>? ?? [];
    final precipProbs = json['precipitation_probability_max'] as List<dynamic>? ?? [];
    final weatherCodes = json['weather_code'] as List<dynamic>? ?? [];

    return DailyForecast(
      date: index < times.length ? times[index].toString() : '',
      maxTemperature: index < maxTemps.length ? (maxTemps[index] as num?)?.toDouble() ?? 0.0 : 0.0,
      minTemperature: index < minTemps.length ? (minTemps[index] as num?)?.toDouble() ?? 0.0 : 0.0,
      precipitationProbabilityMax: index < precipProbs.length ? (precipProbs[index] as num?)?.toInt() ?? 0 : 0,
      weatherCode: index < weatherCodes.length ? (weatherCodes[index] as num?)?.toInt() ?? 0 : 0,
    );
  }
}

class WeatherData {
  final CurrentWeather current;
  final List<DailyForecast> daily;
  final String timezone;

  WeatherData({
    required this.current,
    required this.daily,
    required this.timezone,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};
    final timezoneStr = json['timezone'] as String? ?? 'UTC';

    final dailyTimes = dailyJson['time'] as List<dynamic>? ?? [];
    List<DailyForecast> dailyList = [];
    for (int i = 0; i < dailyTimes.length; i++) {
      dailyList.add(DailyForecast.fromJson(dailyJson, i));
    }

    return WeatherData(
      current: CurrentWeather.fromJson(currentJson),
      daily: dailyList,
      timezone: timezoneStr,
    );
  }
}

// Helper untuk deskripsi cuaca berdasarkan WMO Weather interpretation codes
String weatherDescription(int code) {
  switch (code) {
    case 0:
      return 'Cerah';
    case 1:
    case 2:
    case 3:
      return 'Berawan Sebagian';
    case 45:
    case 48:
      return 'Berkabut';
    case 51:
    case 53:
    case 55:
      return 'Gerimis';
    case 56:
    case 57:
      return 'Gerimis Beku';
    case 61:
    case 63:
    case 65:
      return 'Hujan';
    case 66:
    case 67:
      return 'Hujan Beku';
    case 71:
    case 73:
    case 75:
      return 'Salju';
    case 77:
      return 'Butiran Salju';
    case 80:
    case 81:
    case 82:
      return 'Hujan Lebat';
    case 85:
    case 86:
      return 'Badai Salju';
    case 95:
    case 96:
    case 99:
      return 'Badai Petir';
    default:
      return 'Cerah / Berawan';
  }
}
