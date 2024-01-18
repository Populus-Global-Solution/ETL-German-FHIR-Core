package org.miracum.etl.fhirtoomop.repository.service;

import ca.uhn.fhir.rest.client.api.IGenericClient;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Enumerations.ResourceType;
import org.miracum.etl.fhirtoomop.mapper.helpers.ResourceFhirReferenceUtils;
import org.miracum.etl.fhirtoomop.repository.CareSiteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional("transactionManager")
@Service("CareSiteServiceImpl")
@Slf4j
public class CareSiteServiceImpl {
  @Autowired CareSiteRepository careSiteRepository;

  @Autowired private Boolean goldenMerging;
  @Autowired private Boolean treatPossibleMatchesAsMatch;

  @Autowired IGenericClient client;
  @Autowired ResourceFhirReferenceUtils fhirUtils;

  private final Cache<String, String> logicalIdToGolden =
      Caffeine.newBuilder().maximumSize(1000).build();

  /**
   * Searches if a FHIR Patient resource already exists in person table in OMOP CDM based on the
   * logical id of the FHIR Patient resource.
   *
   * @param logicalId logical id of the Patient resource
   * @return the existing person_id
   */
  @Cacheable(cacheNames = "locations-logicalid", sync = true)
  public Long findCareSiteIdByFhirLogicalId(String logicalId) {
    if (goldenMerging) {
      logicalId = getGoldenResourceByFhirLogicalId(logicalId);
      log.debug("Found golden resource id {}", logicalId);
    }

    var existingCareSite = careSiteRepository.findByFhirLogicalId(logicalId);
    if (existingCareSite == null) {
      return null;
    }
    return existingCareSite.getCareSiteId();
  }

  /**
   * Queries HAPI FHIR MDM for the golden resource ID
   *
   * @param logicalId logical id of the Location resource
   * @return
   */
  public String getGoldenResourceByFhirLogicalId(String logicalId) {
    return logicalIdToGolden.get(
        logicalId,
        key ->
            fhirUtils.getGoldenResourceByFhirLogicalId(
                key, ResourceType.LOCATION.getDisplay(), treatPossibleMatchesAsMatch, client));
  }

  public void deleteCareSiteByFhirId(String fhirLogicalId) {
    careSiteRepository.deleteByFhirLogicalId(fhirLogicalId);
  }
}
