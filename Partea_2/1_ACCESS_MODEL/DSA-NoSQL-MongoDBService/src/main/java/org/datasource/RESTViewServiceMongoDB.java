package org.datasource;

import org.datasource.mongodb.views.departamentscities.CityView;
import org.datasource.mongodb.views.departamentscities.DepartamentView;
import org.datasource.mongodb.views.departamentscities.DepartamentViewBuilder;
import org.datasource.mongodb.views.departamentscities.DepartamentsListView;
// Importurile noi pentru senzori
import org.datasource.mongodb.views.trafficsensors.TrafficSensorView;
import org.datasource.mongodb.views.trafficsensors.TrafficSensorViewBuilder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

/* REST Service URL-uri noi:
    http://localhost:8093/DSA-NoSQL-MongoDBService/rest/transport/TrafficSensorsView
*/
@RestController
@RequestMapping("/transport") // Am schimbat în /transport pentru a se potrivi cu restul proiectului
public class RESTViewServiceMongoDB {
	private static Logger logger = Logger.getLogger(RESTViewServiceMongoDB.class.getName());

	// Injeția builder-elor
	@Autowired private DepartamentViewBuilder departamentViewBuilder;
	@Autowired private TrafficSensorViewBuilder trafficSensorViewBuilder;

	@GetMapping(value = "/ping", produces = MediaType.TEXT_PLAIN_VALUE)
	public String pingDataSource() {
		logger.info(">>>> DSA-NoSQL-MongoDBService is Up!");
		return "Ping response from RESTViewServiceMongoDB!";
	}

	// --- Endpoint-uri noi pentru Senzori (Proiectul tău) ---

	@GetMapping(value = "/TrafficSensorsView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<TrafficSensorView> get_TrafficSensorsView() throws Exception {
		logger.info(">>>> Invocare TrafficSensorsView din MongoDB (proiect)");
		return this.trafficSensorViewBuilder.build().getSensorsViewList();
	}

	// --- Endpoint-uri existente (Departamente/Orașe) ---

	@GetMapping(value = "/DepartamentView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<DepartamentView> get_DepartamentView() throws Exception {
		return this.departamentViewBuilder.build().getDepartamentsViewList();
	}

	@GetMapping(value = "/CityView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CityView> get_CityView() throws Exception {
		return this.departamentViewBuilder.build().getCitiesViewList();
	}

	@GetMapping(value = "/DepartamentsListView", produces = MediaType.APPLICATION_JSON_VALUE)
	public DepartamentsListView get_DepartamentsListView() throws Exception {
		return this.departamentViewBuilder.build().getDepartamentsListView();
	}
}