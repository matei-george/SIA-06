package org.datasource.mongodb.views.trafficsensors;

import java.util.List;

public class TrafficSensorsListView {
    private List<TrafficSensorView> sensors;

    public List<TrafficSensorView> getSensors() { return sensors; }
    public void setSensors(List<TrafficSensorView> sensors) { this.sensors = sensors; }
}