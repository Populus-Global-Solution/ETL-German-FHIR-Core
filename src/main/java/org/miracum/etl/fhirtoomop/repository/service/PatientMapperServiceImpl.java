package org.miracum.etl.fhirtoomop.repository.service;

import ca.uhn.fhir.rest.client.api.IGenericClient;
import com.github.benmanes.caffeine.cache.Cache;
import com.github.benmanes.caffeine.cache.Caffeine;
import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Enumerations.ResourceType;
import org.miracum.etl.fhirtoomop.mapper.helpers.ResourceFhirReferenceUtils;
import org.miracum.etl.fhirtoomop.repository.DeathRepository;
import org.miracum.etl.fhirtoomop.repository.ObservationRepository;
import org.miracum.etl.fhirtoomop.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.caffeine.CaffeineCacheManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * The PatientMapperServiceImpl class contains the specific implementation to access data trough
 * OMOP repositories.
 *
 * @author Elisa Henke
 * @author Yuan Peng
 */
@Transactional(transactionManager = "transactionManager")
@Service("PatientMapperServiceImpl")
@CacheConfig(cacheManager = "caffeineCacheManager")
@Slf4j
public class PatientMapperServiceImpl {
  @Autowired PersonRepository personResRepository;
  @Autowired DeathRepository deathRepository;
  @Autowired ObservationRepository observationRepository;
  @Autowired CaffeineCacheManager cacheManager;

  @Autowired private Boolean goldenMerging;
  @Autowired private Boolean treatPossibleMatchesAsMatch;

  @Autowired IGenericClient client;
  @Autowired ResourceFhirReferenceUtils fhirUtils;

  private final Cache<String, String> logicalIdToGolden =
      Caffeine.newBuilder().maximumSize(10000).build();

  /**
   * Searches if a FHIR Patient resource already exists in person table in OMOP CDM based on the
   * logical id of the FHIR Patient resource.
   *
   * @param logicalId logical id of the Patient resource
   * @return the existing person_id
   */
  @Cacheable(cacheNames = "patients-logicalid", sync = true)
  public Long findPersonIdByFhirLogicalId(String logicalId) {
    if (goldenMerging) {
      logicalId = getGoldenResourceByFhirLogicalId(logicalId);
      log.debug("Found golden resource id {}", logicalId);
    }

    var existingPerson = personResRepository.findByFhirLogicalId(logicalId);
    if (existingPerson == null) {

      return null;
    }
    return existingPerson.getPersonId();
  }

  /**
   * Queries HAPI FHIR MDM for the golden resource ID
   *
   * @param logicalId logical id of the Patient resource
   * @return
   */
  public String getGoldenResourceByFhirLogicalId(String logicalId) {
    return logicalIdToGolden.get(
        logicalId,
        key ->
            fhirUtils.getGoldenResourceByFhirLogicalId(
                logicalId, ResourceType.PATIENT.getDisplay(), treatPossibleMatchesAsMatch, client));
  }

  /**
   * Searches if a FHIR Patient resource already exists in person table in OMOP CDM based on the
   * identifier of the FHIR Patient resource.
   *
   * @param identifier identifier of the Patient resource
   * @return the existing person_id
   */
  @Cacheable(cacheNames = "patients-identifier", sync = true)
  public Long findPersonIdByFhirIdentifier(String identifier) {
    var existingPerson = personResRepository.findByFhirIdentifier(identifier);
    if (existingPerson == null) {
      return null;
    }
    return existingPerson.getPersonId();
  }

  /**
   * Delete FHIR Patient resources from OMOP CDM tables using fhir_logical_id and fhir_identifier
   *
   * @param fhirLogicalId logical id of the FHIR Patient resource
   */
  public void deletePersonByFhirLogicalId(String fhirLogicalId) {
    personResRepository.deleteByFhirLogicalId(fhirLogicalId);
  }

  /**
   * Delete FHIR Patient resources from OMOP CDM tables using fhir_logical_id and fhir_identifier
   *
   * @param fhirIdentifier identifier of the FHIR Patient resource
   */
  public void deletePersonByFhirIdentifier(String fhirIdentifier) {
    personResRepository.deleteByFhirIdentifier(fhirIdentifier);
  }

  /**
   * Delete FHIR Patient resources from OMOP CDM tables using fhir_logical_id and fhir_identifier
   *
   * @param fhirLogicalId logical id of the FHIR Patient resource
   */
  public void deleteExistingDeathByFhirLogicalId(String fhirLogicalId) {
    deathRepository.deleteByFhirLogicalId(fhirLogicalId);
  }

  /**
   * Delete FHIR Patient resources from OMOP CDM tables using fhir_logical_id and fhir_identifier
   *
   * @param fhirIdentifier identifier of the FHIR Patient resource
   */
  public void deleteExistingDeathByFhirIdentifier(String fhirIdentifier) {
    deathRepository.deleteByFhirIdentifier(fhirIdentifier);
  }

  public void deleteExistingCalculatedBirthYearByFhirLogicalId(String fhirLogicalId) {
    observationRepository.deleteByFhirLogicalId(fhirLogicalId);
  }

  public void deleteExistingCalculatedBirthYearByFhirIdentifier(String fhirIdentifier) {
    observationRepository.deleteByFhirIdentifier(fhirIdentifier);
  }
}
