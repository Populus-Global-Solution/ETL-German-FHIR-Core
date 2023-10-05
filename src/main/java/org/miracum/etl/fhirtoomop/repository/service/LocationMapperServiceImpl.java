package org.miracum.etl.fhirtoomop.repository.service;

import lombok.extern.slf4j.Slf4j;
import org.miracum.etl.fhirtoomop.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Transactional("transactionManager")
@Service("LocationMapperServiceImpl")
@Slf4j
public class LocationMapperServiceImpl {
  @Autowired LocationRepository locationRepository;

  public void deleteLocationByFhirId(String fhirLogicalId) {
    locationRepository.deleteByFhirLogicalId(fhirLogicalId);
  }
}
