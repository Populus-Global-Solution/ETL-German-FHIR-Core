package org.miracum.etl.fhirtoomop.mapper;

import com.google.common.base.Strings;
import lombok.extern.slf4j.Slf4j;
import org.hl7.fhir.r4.model.Address;
import org.hl7.fhir.r4.model.Location;
import org.miracum.etl.fhirtoomop.DbMappings;
import org.miracum.etl.fhirtoomop.mapper.helpers.FindOmopConcepts;
import org.miracum.etl.fhirtoomop.mapper.helpers.ResourceFhirReferenceUtils;
import org.miracum.etl.fhirtoomop.model.OmopModelWrapper;
import org.miracum.etl.fhirtoomop.model.omop.CareSite;
import org.miracum.etl.fhirtoomop.model.omop.OmopLocation;
import org.miracum.etl.fhirtoomop.repository.service.CareSiteServiceImpl;
import org.miracum.etl.fhirtoomop.repository.service.LocationMapperServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class LocationMapper implements FhirMapper<Location> {

  private final Boolean bulkload;
  private final DbMappings dbMappings;

  @Autowired ResourceFhirReferenceUtils fhirReferenceUtils;
  @Autowired LocationMapperServiceImpl locationService;
  @Autowired CareSiteServiceImpl careSiteService;
  @Autowired FindOmopConcepts findOmopConcepts;

  @Autowired
  public LocationMapper(Boolean bulkload, DbMappings dbMappings) {
    this.bulkload = bulkload;
    this.dbMappings = dbMappings;
  }

  @Override
  public OmopModelWrapper map(Location location, boolean isDeleted) {
    String locationId = fhirReferenceUtils.extractId(location);

    if (Strings.isNullOrEmpty(locationId)) {
      log.warn("No [Identifier] or [Id] found. [Immunization] resource is invalid. Skip resource");
      // noFhirReferenceCounter.increment();
      return null;
    }

    if (bulkload.equals(Boolean.FALSE) && isDeleted) {
      log.info("Found a deleted resource [{}]. Deleting from OMOP DB.", locationId);

      locationService.deleteLocationByFhirId(locationId);
      careSiteService.deleteCareSiteByFhirId(locationId);
      return null;
    }

    var wrapper = new OmopModelWrapper();

    wrapper.getLocation().add(createNewLocation(location, locationId));
    wrapper.getCareSite().add(createCareSite(location, locationId));

    return wrapper;
  }

  private OmopLocation createNewLocation(Location location, String logicalId) {
    Address address = location.getAddress();
    String addressLine1 = null;
    String addressLine2 = null;
    String city = null;
    String state = null;
    String code = null;
    String country = null;

    if (!address.isEmpty()) {
      city = address.getCity();
      state = address.getState();
      country = address.getCountry();
      code = address.getPostalCode();

      var lines = address.getLine();
      addressLine1 = lines.size() >= 1 ? lines.get(0).asStringValue() : null;
      addressLine2 = lines.size() >= 2 ? lines.get(1).asStringValue() : null;
    }

    return OmopLocation.builder()
        .address_1(addressLine1)
        .address_2(addressLine2)
        .city(city)
        .state(state)
        .zip(code)
        .country_source_value(country)
        .fhirLogicalId(logicalId)
        .build();
  }

  private CareSite createCareSite(Location location, String locationLogicalId) {
    return CareSite.builder()
        .careSiteName(location.getName())
        .careSiteSourceValue(location.getDescription())
        .fhirLogicalId(locationLogicalId)
        .build();
  }
}
