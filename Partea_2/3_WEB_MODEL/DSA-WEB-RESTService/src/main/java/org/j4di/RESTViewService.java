package org.j4di;

import org.j4di.analytical.views.AnalyticalTransportMaster;
import org.j4di.analytical.views.AnalyticalTransportMasterRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Logger;

/* REST Service URL Final:
    http://localhost:8096/DSA-WEB-RESTService/rest/OLAP/AnalyticalTransportMaster
*/
@RestController
@RequestMapping("/rest/OLAP") // Prefix definit în context-path și adnotare
public class RESTViewService {
	private static Logger logger = Logger.getLogger(RESTViewService.class.getName());

	@RequestMapping(value = "/ping", method = RequestMethod.GET,
			produces = {MediaType.TEXT_PLAIN_VALUE})
	@ResponseBody
	public String pingDataSource() {
		logger.info(">>>> DSA-WEB-SparkService:: RESTViewService is Up!");
		return "Ping response from DSA-WEB-SparkService!";
	}

	// --- Injectare Repository pentru Modelul Analitic de Transport ---
	@Autowired
	private AnalyticalTransportMasterRepository analyticalTransportRepository;

	/**
	 * Endpoint pentru vizualizarea datelor federate (Postgres + CSV + MongoDB).
	 * Rulează interogarea pe vederea din SparkSQL definită în Repository. [cite: 51, 60]
	 */
	@GetMapping(value = "/AnalyticalTransportMaster",
			produces = {MediaType.APPLICATION_JSON_VALUE})
	@ResponseBody
	public List<AnalyticalTransportMaster> get_AnalyticalTransportMaster() {
		logger.info(">>>> Invocare AnalyticalTransportMaster din SparkSQL Remote View");

		// Apelăm metoda definită în Repository-ul tău [cite: 53, 58]
		List<AnalyticalTransportMaster> viewList =
				this.analyticalTransportRepository.get_AnalyticalTransportMaster();

		return viewList;
	}
}