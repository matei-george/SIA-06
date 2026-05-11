package org.datasource.csv.trips;

import org.springframework.beans.factory.annotation.Value; // Corect: Importul pentru Spring @Value
import org.springframework.core.io.ClassPathResource;    // Lipsea
import org.springframework.stereotype.Component;
import java.io.BufferedReader;                          // Lipsea
import java.io.InputStreamReader;                       // Lipsea
import java.util.ArrayList;
import java.util.List;

@Component
public class TripsViewBuilder {
    private List<TripsView> viewList = new ArrayList<>();

    // Eroare reparată: staticConstructor nu există la Spring @Value
    @Value("${csv.data.source.file.path.trips}")
    private String csvFilePath;

    public TripsViewBuilder build() throws Exception {
        this.viewList.clear();
        int rowLimit = 100;
        int count = 0;

        // Folosim ClassPathResource pentru a citi din resources/datasource/trips.csv
        ClassPathResource resource = new ClassPathResource(csvFilePath);

        try (BufferedReader br = new BufferedReader(new InputStreamReader(resource.getInputStream()))) {
            br.readLine(); // Sărim peste header (capul de tabel)
            String line;
            while ((line = br.readLine()) != null && count < rowLimit) {
                // Split după virgulă
                String[] v = line.split(",");
                if (v.length >= 5) {
                    this.viewList.add(new TripsView(
                            v[0].trim(), // route_id
                            v[1].trim(), // service_id
                            v[2].trim(), // trip_id
                            v[3].trim(), // trip_headsign
                            v[4].trim()  // direction_id
                    ));
                    count++;
                }
            }
        }
        return this;
    }

    public List<TripsView> getViewList() {
        return viewList;
    }
}