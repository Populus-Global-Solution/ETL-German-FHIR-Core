package org.miracum.etl.fhirtoomop.repository;

import org.miracum.etl.fhirtoomop.model.omop.OmopLocation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.transaction.annotation.Transactional;

/**
 * The LocationRepository interface represents a repository for the location table in OMOP CDM.
 *
 * @author Elisa Henke
 * @author Yuan Peng
 */
public interface LocationRepository
    extends PagingAndSortingRepository<OmopLocation, Long>, JpaRepository<OmopLocation, Long> {

  void deleteByFhirLogicalId(String fhirLogicalId);

  OmopLocation findByFhirLogicalId(String fhirLogicalId);

  @Transactional
  @Modifying
  @Query(value = "TRUNCATE TABLE location CASCADE", nativeQuery = true)
  void truncateTable();
}
