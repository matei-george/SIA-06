package org.datasource.jdbc.views.trips;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.springframework.stereotype.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class TripsPostgresViewBuilder {
    private static Logger logger = Logger.getLogger(TripsPostgresViewBuilder.class.getName());

    // SQL pentru tabelul tău de Postgres
    private String SQL_TRIPS_SELECT = "SELECT trip_id, transport_type, route_id, origin_station, destination_station FROM transport.trips";

    private Integer fetchOffset = -1;
    private Integer fetchSize = 100; // Limita setată la 100 conform discuției

    // DataCache
    private List<TripsPostgresView> tripsViewList = new ArrayList<>();

    /* JDBC Session Management ---------------------------------------- */
    private JDBCDataSourceConnector jdbcConnector;

    // Constructor Injection (Stilul cerut)
    public TripsPostgresViewBuilder(JDBCDataSourceConnector jdbcConnector) {
        this.jdbcConnector = jdbcConnector;
    }

    public List<TripsPostgresView> getViewList() {
        return this.tripsViewList;
    }

    // Building steps
    public TripsPostgresViewBuilder build() {
        logger.info(">>> Building TripsPostgresView: fetchOffset=" + fetchOffset + ", fetchSize=" + fetchSize);

        try (Connection jdbcConnection = jdbcConnector.getConnection()) {
            String sql = SQL_TRIPS_SELECT;
            PreparedStatement selectStmt;

            // Logica de paginare (Fetch)
            if (fetchOffset != null && fetchOffset > 0) {
                sql = String.format(SQL_FETCH_SELECT, SQL_TRIPS_SELECT);
                selectStmt = jdbcConnection.prepareStatement(sql);
                selectStmt.setInt(1, fetchOffset);
                selectStmt.setInt(2, fetchOffset + fetchSize);
                logger.info(">>> SQL_FETCH_SELECT formatted:\n" + sql);
            } else {
                // Dacă nu avem offset, punem o limită simplă pentru siguranță
                sql = SQL_TRIPS_SELECT + " LIMIT " + fetchSize;
                selectStmt = jdbcConnection.prepareStatement(sql);
            }

            // Execuție
            ResultSet rs = selectStmt.executeQuery();

            // Mapare date
            tripsViewList = new ArrayList<>();
            while (rs.next()) {
                this.tripsViewList.add(new TripsPostgresView(
                        rs.getString("trip_id"),
                        rs.getString("transport_type"),
                        rs.getString("route_id"),
                        rs.getString("origin_station"),
                        rs.getString("destination_station")
                ));
            }

        } catch (Exception ex) {
            logger.severe(">>> Error building TripsPostgresView: " + ex.getMessage());
            ex.printStackTrace();
        }

        return this;
    }

    public TripsPostgresViewBuilder setFetchOffset(Integer fetchOffset) {
        if (fetchOffset != null) this.fetchOffset = fetchOffset;
        return this;
    }

    public TripsPostgresViewBuilder setFetchSize(Integer fetchSize) {
        if (fetchSize != null) this.fetchSize = fetchSize;
        return this;
    }

    private String SQL_FETCH_SELECT = """
          SELECT *
            FROM (
                 SELECT Q_.*,
                        ROW_NUMBER() OVER(
                                ORDER BY 1
                        ) RN___
                   FROM (
                        %s
                 ) Q_
          ) Q__
           WHERE RN___ BETWEEN ? AND ?
          """;
}