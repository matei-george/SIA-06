package org.datasource.csv.trips;

public record TripsView(
        String routeId,
        String serviceId,
        String tripId,
        String tripHeadsign,
        String directionId
) {}