package org.datasource;

import org.datasource.jdbc.JDBCDataSourceConnector;
import org.datasource.jdbc.views.customerdetails.CustomerDetailsView;
import org.datasource.jdbc.views.customerdetails.CustomerDetailsViewBuilder;
import org.datasource.jdbc.views.customers.CustomerView;
import org.datasource.jdbc.views.customers.CustomerViewBuilder;
import org.datasource.jdbc.views.customersadresses.CustomerAddressesView;
import org.datasource.jdbc.views.customersadresses.CustomerAddressesViewBuilder;
import org.datasource.jdbc.views.metrics.MetricsPostgresView;
import org.datasource.jdbc.views.metrics.MetricsPostgresViewBuilder;
import org.datasource.jdbc.views.trips.TripsPostgresView; // Asigură-te că importul ăsta există
import org.datasource.jdbc.views.trips.TripsPostgresViewBuilder;
import org.datasource.jdbc.views.weather.WeatherPostgresView;
import org.datasource.jdbc.views.weather.WeatherPostgresViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

@RestController
@RequestMapping("/transport")
public class RESTViewServiceJDBC {
	private static Logger logger = Logger.getLogger(RESTViewServiceJDBC.class.getName());

	// Injeția builder-elor
	@Autowired private JDBCDataSourceConnector jdbcConnector;
	@Autowired private WeatherPostgresViewBuilder weatherPostgresViewBuilder;
	@Autowired private MetricsPostgresViewBuilder metricsPostgresViewBuilder;
	@Autowired private CustomerViewBuilder customersViewBuilder;
	@Autowired private CustomerDetailsViewBuilder customersDetailsViewBuilder;
	@Autowired private CustomerAddressesViewBuilder customersAddressesViewBuilder;
	@Autowired private TripsPostgresViewBuilder tripsPostgresViewBuilder;

	// 1. Endpoint PING
	@GetMapping(value = "/ping", produces = MediaType.TEXT_PLAIN_VALUE)
	public String ping() {
		logger.info(">>>> DSA-SQL-JDBCService:: RESTViewService is Up!");
		return "Ping response from DSA-SQL-JDBCService!";
	}

	// 2. Endpoint TRIPS (Cel nou pentru tine)
	@GetMapping(value = "/TripsPostgresView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<TripsPostgresView> get_TripsPostgresView() {
		// Aici apelăm builder-ul tău nou pentru Postgres
		return tripsPostgresViewBuilder.build().getViewList();
	}

	// 3. Endpoint CUSTOMERS
	@GetMapping(value = "/CustomerView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CustomerView> get_CustomerView() {
		return customersViewBuilder.build().getViewList();
	}

	// 4. Endpoint CUSTOMERS cu Offset/Size
	@GetMapping(value = "/CustomerViewData", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CustomerView> get_CustomerViewData(
			@RequestParam("fetch_offset") Integer fetchOffset,
			@RequestParam("fetch_size") Integer fetchSize
	) {
		return customersViewBuilder
				.setFetchOffset(fetchOffset)
				.setFetchSize(fetchSize)
				.build().getViewList();
	}

	// 5. Endpoint CUSTOMER DETAILS
	@GetMapping(value = "/CustomerDetailsView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CustomerDetailsView> get_CustomerDetailsView() {
		return customersDetailsViewBuilder.build().getViewList();
	}

	// 6. Endpoint CUSTOMER ADDRESSES
	@GetMapping(value = "/CustomerAddressesView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CustomerAddressesView> get_CustomerAddressesView() {
		return customersAddressesViewBuilder.build().getViewList();
	}

	@GetMapping(value = "/WeatherPostgresView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<WeatherPostgresView> get_WeatherPostgresView() {
		return weatherPostgresViewBuilder.build().getViewList();
	}
	@GetMapping(value = "/MetricsPostgresView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<MetricsPostgresView> get_MetricsPostgresView() {
		return metricsPostgresViewBuilder.build().getViewList();
	}
}