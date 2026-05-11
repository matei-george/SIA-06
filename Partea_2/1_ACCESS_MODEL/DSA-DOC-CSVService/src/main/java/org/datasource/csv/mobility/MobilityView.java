package org.datasource.csv.mobility;

public record MobilityView(
        String vehicleId,
        String vehicleType,
        String speed,
        String fuelLevel,
        String weather
) {}