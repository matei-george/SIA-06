package org.datasource.jdbc.views.trips;

public record TripsPostgresView(
        String tripId,
        String transportType,
        String routeId,
        String originStation,
        String destinationStation
) {}