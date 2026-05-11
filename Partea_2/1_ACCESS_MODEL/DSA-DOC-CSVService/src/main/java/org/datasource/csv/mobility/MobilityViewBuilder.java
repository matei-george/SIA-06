package org.datasource.csv.mobility;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

@Component
public class MobilityViewBuilder {
    private List<MobilityView> viewList = new ArrayList<>();

    @Value("${csv.data.source.file.path.mobility}")
    private String csvFilePath;

    public MobilityViewBuilder build() throws Exception {
        this.viewList.clear();
        int rowLimit = 100;
        int count = 0;

        ClassPathResource resource = new ClassPathResource(csvFilePath);
        try (BufferedReader br = new BufferedReader(new InputStreamReader(resource.getInputStream()))) {
            br.readLine(); // Skip header
            String line;
            while ((line = br.readLine()) != null && count < rowLimit) {
                String[] v = line.split(",");
                // Mapăm: Vehicle_ID(0), Vehicle_Type(1), Speed_kmh(4), Fuel_Level(5), Weather(8)
                if (v.length >= 9) {
                    this.viewList.add(new MobilityView(
                            v[0].trim(), v[1].trim(), v[4].trim(), v[5].trim(), v[8].trim()
                    ));
                    count++;
                }
            }
        }
        return this;
    }
    public List<MobilityView> getViewList() { return viewList; }
}