package org.datasource.jdbc.views.weather;

public record WeatherPostgresView(
        String tripId,
        String weatherCondition,
        Double temperatureC,
        Integer humidityPercent,
        Integer windSpeedKmh,
        Double precipitationMm
) {}