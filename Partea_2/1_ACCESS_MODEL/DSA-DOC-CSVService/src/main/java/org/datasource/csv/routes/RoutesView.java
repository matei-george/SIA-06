package org.datasource.csv.routes;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoutesView {
    private String routeId;
    private String agencyId;
    private String routeShortName;
    private String routeLongName;
    private String routeType;
}