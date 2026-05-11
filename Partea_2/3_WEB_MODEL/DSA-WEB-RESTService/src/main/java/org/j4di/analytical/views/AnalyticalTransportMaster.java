package org.j4di.analytical.views;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

/**
 * Entitate JPA care mapeaza structura vederii analitice din SparkSQL.
 * Se conecteaza prin HIVE-JDBC conform setarilor din application.properties[cite: 45, 73].
 */
@Entity
@Table(name = "view_analytical_transport_master")
public class AnalyticalTransportMaster {

    @Id
    private String tripId;
    private String transportType;
    private String originStation;
    private String routeLongName;
    private Integer pg_traffic_index;
    private Boolean is_delayed;
    private Integer mongo_sensor_index;
    private String sensor_weather;

    // --- Constructor fara argumente (necesar pentru JPA) ---
    public AnalyticalTransportMaster() {
    }

    // --- Getters si Setters ---

    public String getTripId() {
        return tripId;
    }

    public void setTripId(String tripId) {
        this.tripId = tripId;
    }

    public String getTransportType() {
        return transportType;
    }

    public void setTransportType(String transportType) {
        this.transportType = transportType;
    }

    public String getOriginStation() {
        return originStation;
    }

    public void setOriginStation(String originStation) {
        this.originStation = originStation;
    }

    public String getRouteLongName() {
        return routeLongName;
    }

    public void setRouteLongName(String routeLongName) {
        this.routeLongName = routeLongName;
    }

    public Integer getPg_traffic_index() {
        return pg_traffic_index;
    }

    public void setPg_traffic_index(Integer pg_traffic_index) {
        this.pg_traffic_index = pg_traffic_index;
    }

    public Boolean getIs_delayed() {
        return is_delayed;
    }

    public void setIs_delayed(Boolean is_delayed) {
        this.is_delayed = is_delayed;
    }

    public Integer getMongo_sensor_index() {
        return mongo_sensor_index;
    }

    public void setMongo_sensor_index(Integer mongo_sensor_index) {
        this.mongo_sensor_index = mongo_sensor_index;
    }

    public String getSensor_weather() {
        return sensor_weather;
    }

    public void setSensor_weather(String sensor_weather) {
        this.sensor_weather = sensor_weather;
    }
}