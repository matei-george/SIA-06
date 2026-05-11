package org.datasource.mongodb.views.trafficsensors;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.datasource.mongodb.MongoDataSourceConnector;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@Service
public class TrafficSensorViewBuilder {
    private static Logger logger = Logger.getLogger(TrafficSensorViewBuilder.class.getName());

    // Data cache - acum este o listă directă de obiecte mapate
    private List<TrafficSensorView> sensorsViewList = new ArrayList<>();

    public List<TrafficSensorView> getSensorsViewList() {
        return sensorsViewList;
    }

    private MongoDataSourceConnector dataSourceConnector;

    // Constructor Injection
    public TrafficSensorViewBuilder(MongoDataSourceConnector dataSourceConnector) {
        this.dataSourceConnector = dataSourceConnector;
    }

    // Builder Workflow
    public TrafficSensorViewBuilder build() throws Exception {
        return this.select().map();
    }

    // Pasul 1: Extracția datelor
    public TrafficSensorViewBuilder select() throws Exception {
        logger.info(">>> Selecting data from MongoDB: collection=traffic_sensors");

        // Obținem baza de date "proiect" (configurată în application.properties)
        MongoDatabase db = dataSourceConnector.getMongoDatabase();

        // Măsurăm direct colecția de senzori
        MongoCollection<TrafficSensorView> sensorsCollection =
                db.getCollection("traffic_sensors", TrafficSensorView.class);

        // Resetăm lista și citim toate documentele (limitat la 100 pentru performanță)
        this.sensorsViewList = new ArrayList<>();
        sensorsCollection.find().limit(100).into(this.sensorsViewList);

        logger.info(">>> Found " + this.sensorsViewList.size() + " sensor documents.");

        return this;
    }

    // Pasul 2: Mapare (în acest caz, datele sunt deja mapate de driverul POJO)
    private TrafficSensorViewBuilder map() {
        // Dacă e nevoie de transformări suplimentare (ex: calculat coloane noi), se fac aici.
        // Momentan, lista este deja populată de select().
        if (this.sensorsViewList == null) {
            this.sensorsViewList = new ArrayList<>();
        }
        return this;
    }
}