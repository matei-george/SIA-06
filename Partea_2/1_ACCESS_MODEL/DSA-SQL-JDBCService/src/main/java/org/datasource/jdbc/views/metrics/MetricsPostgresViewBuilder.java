package org.datasource.jdbc.views.metrics;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.springframework.stereotype.Service;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class MetricsPostgresViewBuilder {
    private static Logger logger = Logger.getLogger(MetricsPostgresViewBuilder.class.getName());

    private String SQL_METRICS_SELECT = "SELECT trip_id, event_type, event_attendance_est, traffic_congestion_index, holiday, peak_hour, weekday, season, delayed FROM transport.metrics";

    private Integer fetchOffset = -1;
    private Integer fetchSize = 100;

    private List<MetricsPostgresView> metricsViewList = new ArrayList<>();
    private JDBCDataSourceConnector jdbcConnector;

    public MetricsPostgresViewBuilder(JDBCDataSourceConnector jdbcConnector) {
        this.jdbcConnector = jdbcConnector;
    }

    public List<MetricsPostgresView> getViewList() {
        return this.metricsViewList;
    }

    public MetricsPostgresViewBuilder build() {
        logger.info(">>> Building MetricsPostgresView: offset=" + fetchOffset + ", size=" + fetchSize);

        try (Connection jdbcConnection = jdbcConnector.getConnection()) {
            String sql = SQL_METRICS_SELECT;
            PreparedStatement selectStmt;

            if (fetchOffset != null && fetchOffset > 0) {
                sql = String.format(SQL_FETCH_SELECT, SQL_METRICS_SELECT);
                selectStmt = jdbcConnection.prepareStatement(sql);
                selectStmt.setInt(1, fetchOffset);
                selectStmt.setInt(2, fetchOffset + fetchSize);
            } else {
                sql = SQL_METRICS_SELECT + " LIMIT " + fetchSize;
                selectStmt = jdbcConnection.prepareStatement(sql);
            }

            ResultSet rs = selectStmt.executeQuery();
            metricsViewList = new ArrayList<>();

            while (rs.next()) {
                this.metricsViewList.add(new MetricsPostgresView(
                        rs.getString("trip_id"),
                        rs.getString("event_type"),
                        rs.getInt("event_attendance_est"),
                        rs.getInt("traffic_congestion_index"),
                        rs.getBoolean("holiday"),
                        rs.getBoolean("peak_hour"),
                        rs.getInt("weekday"),
                        rs.getString("season"),
                        rs.getBoolean("delayed")
                ));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return this;
    }

    public MetricsPostgresViewBuilder setFetchOffset(Integer fetchOffset) {
        if (fetchOffset != null) this.fetchOffset = fetchOffset;
        return this;
    }
    public MetricsPostgresViewBuilder setFetchSize(Integer fetchSize) {
        if (fetchSize != null) this.fetchSize = fetchSize;
        return this;
    }

    private String SQL_FETCH_SELECT = "SELECT * FROM (SELECT Q_.*, ROW_NUMBER() OVER(ORDER BY 1) RN___ FROM (%s) Q_) Q__ WHERE RN___ BETWEEN ? AND ?";
}