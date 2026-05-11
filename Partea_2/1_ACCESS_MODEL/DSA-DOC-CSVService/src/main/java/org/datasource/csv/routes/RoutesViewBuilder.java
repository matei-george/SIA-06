package org.datasource.csv.routes;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

@Component
public class RoutesViewBuilder {
    private List<RoutesView> viewList = new ArrayList<>();

    @Value("${csv.data.source.file.path.routes}")
    private String csvFilePath;

    public List<RoutesView> getViewList() {
        return viewList;
    }

    public RoutesViewBuilder build() throws Exception {
        this.viewList.clear();
        int rowLimit = 100; // Limităm la 100 de rânduri pentru performanță
        int currentCount = 0;

        ClassPathResource resource = new ClassPathResource(csvFilePath);

        try (BufferedReader br = new BufferedReader(new InputStreamReader(resource.getInputStream()))) {
            String line;
            br.readLine(); // Sărim peste header

            while ((line = br.readLine()) != null && currentCount < rowLimit) {
                // Folosim split limitat pentru a nu procesa virgule inutile de la finalul rândului
                String[] values = line.split(",");

                if (values.length >= 8) {
                    this.viewList.add(new RoutesView(
                            values[3].trim(),  // routeId
                            values[0].trim(),  // agencyId
                            values[5].trim(),  // routeShortName
                            values[4].trim(),  // routeLongName
                            values[7].trim()   // routeType
                    ));
                    currentCount++;
                }
            }
        }
        return this;
    }
}