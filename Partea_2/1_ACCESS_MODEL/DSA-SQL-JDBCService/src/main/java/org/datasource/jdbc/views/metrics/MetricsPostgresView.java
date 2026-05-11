package org.datasource.jdbc.views.metrics;

public record MetricsPostgresView(
        String tripId,
        String eventType,
        Integer eventAttendanceEst,
        Integer trafficCongestionIndex,
        Boolean holiday,
        Boolean peakHour,
        Integer weekday,
        String season,
        Boolean delayed
) {}