package org.j4di.analytical.views;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import java.util.List;

/**
 * Repository pentru accesul la vederea analitica federata din SparkSQL[cite: 53].
 * Gestioneaza maparea datelor catre entitatea AnalyticalTransportMaster[cite: 78].
 */
@Repository
public interface AnalyticalTransportMasterRepository
        extends JpaRepository<AnalyticalTransportMaster, String> {

    /**
     * Metoda personalizata pentru a returna toate inregistrarile din vederea Spark[cite: 60].
     * Aceasta va executa: SELECT * FROM view_analytical_transport_master.
     */
    @Query(value = "SELECT * FROM view_analytical_transport_master", nativeQuery = true)
    List<AnalyticalTransportMaster> get_AnalyticalTransportMaster();
}