package org.datasource.jdbc.views.weather;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.springframework.stereotype.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class WeatherPostgresViewBuilder {
    private static Logger logger = Logger.getLogger(WeatherPostgresViewBuilder.class.getName());

    private String SQL_WEATHER_SELECT = "SELECT trip_id, weather_condition, temperature_C, humidity_percent, wind_speed_kmh, precipitation_mm FROM transport.weather";

    private Integer fetchOffset = -1;
    private Integer fetchSize = 100;

    private List<WeatherPostgresView> weatherViewList = new ArrayList<>();
    private JDBCDataSourceConnector jdbcConnector;

    public WeatherPostgresViewBuilder(JDBCDataSourceConnector jdbcConnector) {
        this.jdbcConnector = jdbcConnector;
    }

    public List<WeatherPostgresView> getViewList() {
        return this.weatherViewList;
    }

    public WeatherPostgresViewBuilder build() {
        logger.info(">>> Building WeatherPostgresView: offset=" + fetchOffset + ", size=" + fetchSize);

        try (Connection jdbcConnection = jdbcConnector.getConnection()) {
            String sql = SQL_WEATHER_SELECT;
            PreparedStatement selectStmt;

            if (fetchOffset != null && fetchOffset > 0) {
                sql = String.format(SQL_FETCH_SELECT, SQL_WEATHER_SELECT);
                selectStmt = jdbcConnection.prepareStatement(sql);
                selectStmt.setInt(1, fetchOffset);
                selectStmt.setInt(2, fetchOffset + fetchSize);
            } else {
                sql = SQL_WEATHER_SELECT + " LIMIT " + fetchSize;
                selectStmt = jdbcConnection.prepareStatement(sql);
            }

            ResultSet rs = selectStmt.executeQuery();
            weatherViewList = new ArrayList<>();

            while (rs.next()) {
                this.weatherViewList.add(new WeatherPostgresView(
                        rs.getString("trip_id"),
                        rs.getString("weather_condition"),
                        rs.getDouble("temperature_C"),
                        rs.getInt("humidity_percent"),
                        rs.getInt("wind_speed_kmh"),
                        rs.getDouble("precipitation_mm")
                ));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return this;
    }

    // Metodele de setare pentru paginare (identice cu CustomerViewBuilder)
    public WeatherPostgresViewBuilder setFetchOffset(Integer fetchOffset) {
        if (fetchOffset != null) this.fetchOffset = fetchOffset;
        return this;
    }
    public WeatherPostgresViewBuilder setFetchSize(Integer fetchSize) {
        if (fetchSize != null) this.fetchSize = fetchSize;
        return this;
    }

    private String SQL_FETCH_SELECT = "SELECT * FROM (SELECT Q_.*, ROW_NUMBER() OVER(ORDER BY 1) RN___ FROM (%s) Q_) Q__ WHERE RN___ BETWEEN ? AND ?";
}