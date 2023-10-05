package org.miracum.etl.fhirtoomop.listeners;

import javax.batch.api.listener.StepListener;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class LocationStepListener implements StepListener {
  @Override
  public void beforeStep() throws Exception {}

  @Override
  public void afterStep() throws Exception {}
}
