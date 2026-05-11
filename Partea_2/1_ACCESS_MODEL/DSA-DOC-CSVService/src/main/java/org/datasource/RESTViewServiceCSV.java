package org.datasource;

import org.datasource.csv.custcategories.CustomerCategoryView;
import org.datasource.csv.custcategories.CustomerEmpCategoryCSVViewBuilder;
import org.datasource.csv.mobility.MobilityView;
import org.datasource.csv.mobility.MobilityViewBuilder;
import org.datasource.csv.routes.RoutesView;
import org.datasource.csv.routes.RoutesViewBuilder;
import org.datasource.csv.trips.TripsView;
import org.datasource.csv.trips.TripsViewBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/transport")
public class RESTViewServiceCSV {

	@Autowired
	private CustomerEmpCategoryCSVViewBuilder customerEmpCategoryCSVViewBuilder;

	@Autowired
	private RoutesViewBuilder routesViewBuilder;

	@Autowired
	private TripsViewBuilder tripsViewBuilder; // Am uniformizat numele aici

	@Autowired
	private MobilityViewBuilder mobilityViewBuilder;

	// 1. Endpoint pentru datele originale din laborator (Clienți/Angajați)
	@GetMapping(value = "/CustomerEmployeesCategoryViewCSV", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<CustomerCategoryView> get_CustomerEmployeesCategoryViewCSV() throws Exception {
		// Modelul recomandat: rebuild la fiecare cerere pentru a reflecta schimbările din fișier
		return this.customerEmpCategoryCSVViewBuilder.build().getViewList();
	}

	// 2. Endpoint pentru fișierul tău routes.csv
	@GetMapping(value = "/RoutesView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<RoutesView> get_RoutesView() throws Exception {
		return this.routesViewBuilder.build().getViewList();
	}

	// 3. Endpoint pentru noul fișier trips.csv
	@GetMapping(value = "/TripsView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<TripsView> get_TripsView() throws Exception {
		return this.tripsViewBuilder.build().getViewList();
	}

	@GetMapping(value = "/MobilityView", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<MobilityView> get_MobilityView() throws Exception {
		return this.mobilityViewBuilder.build().getViewList();
	}
}