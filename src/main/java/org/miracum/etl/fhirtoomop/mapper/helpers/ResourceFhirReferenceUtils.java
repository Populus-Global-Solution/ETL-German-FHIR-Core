package org.miracum.etl.fhirtoomop.mapper.helpers;

import static org.miracum.etl.fhirtoomop.Constants.FHIR_RESOURCE_CONSENT;

import ca.uhn.fhir.fhirpath.IFhirPath;
import ca.uhn.fhir.rest.client.api.IGenericClient;
import ca.uhn.fhir.rest.server.exceptions.InvalidRequestException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Pattern;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.hl7.fhir.instance.model.api.IBaseResource;
import org.hl7.fhir.r4.model.Parameters;
import org.hl7.fhir.r4.model.Reference;
import org.hl7.fhir.r4.model.Resource;
import org.hl7.fhir.r4.model.StringType;
import org.miracum.etl.fhirtoomop.config.FhirSystems;

/**
 * The ResourceFhirReferenceUtils class is used to extract references to other FHIR resources from
 * the processing FHIR resource.
 *
 * @author Elisa Henke
 * @author Yuan Peng
 */
@Slf4j
public class ResourceFhirReferenceUtils {

  private final IFhirPath fhirPath;
  private final FhirSystems fhirSystems;
  private final Pattern uuidRegex =
      Pattern.compile(
          "[0-9a-fA-F]{8}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{4}\\b-[0-9a-fA-F]{12}");

  /**
   * Constructor for objects of the class ResourceFhirReferenceUtils.
   *
   * @param fhirPath FhirPath engine to evaluate path expressions over FHIR resources
   * @param fhirSystems reference to naming and coding systems used in FHIR resources
   */
  public ResourceFhirReferenceUtils(IFhirPath fhirPath, FhirSystems fhirSystems) {
    this.fhirPath = fhirPath;
    this.fhirSystems = fhirSystems;
  }

  /**
   * Extracts the identifier of a referenced FHIR Patient resource from a FHIR resource.
   *
   * @param resource FHIR resource
   * @return identifier of a referenced FHIR Patient resource
   */
  public String getSubjectReferenceIdentifier(IBaseResource resource) {
    var subjectIdentifierByTypePath = "subject.identifier.value";
    var subjectIdentifier =
        fhirPath.evaluateFirst(resource, subjectIdentifierByTypePath, StringType.class);

    var patientIdentifierByTypePath = "patient.identifier.value";
    var patientIdentifier =
        fhirPath.evaluateFirst(resource, patientIdentifierByTypePath, StringType.class);

    if (!subjectIdentifier.isPresent() && !patientIdentifier.isPresent()) {
      return null;
    } else {
      return "pat-"
          + (subjectIdentifier.isPresent()
              ? subjectIdentifier.get().getValue()
              : patientIdentifier.get().getValue());
    }
  }

  /**
   * Extracts the logical id of a referenced FHIR Patient resource from a FHIR resource.
   *
   * @param resource FHIR resource
   * @return logical id of a referenced FHIR Patient resource
   */
  public String getSubjectReferenceLogicalId(IBaseResource resource) {
    var subjectReferencePath = "subject.reference";
    var subjectLogicalId = fhirPath.evaluateFirst(resource, subjectReferencePath, StringType.class);

    var patientReferencePath = "patient.reference";
    var patientLogicalId = fhirPath.evaluateFirst(resource, patientReferencePath, StringType.class);

    if (!subjectLogicalId.isPresent() && !patientLogicalId.isPresent()) {
      return null;
    } else {
      var reference =
          new Reference(
              subjectLogicalId.isPresent()
                  ? subjectLogicalId.get().getValue()
                  : patientLogicalId.get().getValue());
      return "pat-" + reference.getReferenceElement().getIdPart().replace("urn:uuid:", "");
    }
  }

  /**
   * Extracts the identifier of a referenced FHIR Encounter resource from a FHIR resource.
   *
   * @param resource FHIR resource
   * @return identifier of a referenced FHIR Encounter resource
   */
  public String getEncounterReferenceIdentifier(IBaseResource resource) {
    var identifierByTypePath = "encounter.identifier.value";
    var identifier = fhirPath.evaluateFirst(resource, identifierByTypePath, StringType.class);

    if (identifier.isPresent()) {

      return "enc-" + identifier.get().getValue();
    }

    return null;
  }

  /**
   * Extracts the logical id of a referenced FHIR Encounter resource from a FHIR resource.
   *
   * @param resource FHIR resource
   * @return logical id of a referenced FHIR Encounter resource
   */
  public String getEncounterReferenceLogicalId(IBaseResource resource) {

    var referencePath = "encounter.reference";
    var logicalId = fhirPath.evaluateFirst(resource, referencePath, StringType.class);

    if (logicalId.isPresent()) {
      var reference = new Reference(logicalId.get().getValue());

      return "enc-" + reference.getReferenceElement().getIdPart();
    }

    return null;
  }

  /**
   * Extracts the identifier from a FHIR resource.
   *
   * @param resource processing FHIR resource
   * @param typeCode code of the identifier type of the FHIR resource
   * @return identifier from the processing FHIR resource
   */
  public String extractIdentifier(Resource resource, String typeCode) {
    var identifierByTypePath =
        String.format(
            "identifier.where(type.coding.where(system='%s' and code='%s').exists()).value",
            fhirSystems.getIdentifierType(), typeCode);
    var identifierList = fhirPath.evaluate(resource, identifierByTypePath, StringType.class);

    if (identifierList.isEmpty()) {
      return null;
    }

    var identifer =
        identifierList.stream().map(Objects::toString).filter(StringUtils::isNotBlank).findFirst();
    if (identifer.isPresent()) {
      var prefix = getResourceTypePrefix(resource);
      if (prefix != null) {
        return prefix + identifer.get();
      }
    }

    return null;
  }

  /**
   * Extracts the logical id from a FHIR resource.
   *
   * @param resource processing FHIR resource
   * @return logical id from the processing FHIR resource
   */
  public String extractId(Resource resource) {
    if (!resource.hasId()) {
      log.debug("Given [{}] has no identifying source value", resource.getResourceType());
      return null;
    }
    var prefix = getResourceTypePrefix(resource);
    if (prefix != null) {
      return prefix + resource.getIdElement().getIdPart();
    }
    return null;
  }

  public String getResourceTypePrefix(String resourceType) {
    var resourceTypeSplit = resourceType.split("(?=\\p{Upper})");
    switch (resourceTypeSplit.length) {
      case 1:
        if (resourceTypeSplit[0].equals(FHIR_RESOURCE_CONSENT)) {
          return resourceTypeSplit[0].substring(0, 4).toLowerCase() + "-";
        }
        return resourceTypeSplit[0].substring(0, 3).toLowerCase() + "-";
      case 2:
        return (resourceTypeSplit[0].substring(0, 2) + resourceTypeSplit[1].substring(0, 1))
                .toLowerCase()
            + "-";
      default:
        log.error("No Resource Type found, invalid resource, please check!");
        return null;
    }
  }

  private String getResourceTypePrefix(IBaseResource resource) {
    return getResourceTypePrefix(resource.fhirType());
  }

  /**
   * Extracts the first found identifier from the FHIR resource.
   *
   * @param resource FHIR resource
   * @return first found identifier from FHIR resource
   */
  public String extractResourceFirstIdentifier(Resource resource) {
    var identifierPath = "identifier.value";
    var identifierList = fhirPath.evaluate(resource, identifierPath, StringType.class);
    if (identifierList.isEmpty()) {
      return null;
    }

    var identifer =
        identifierList.stream().map(Objects::toString).filter(StringUtils::isNotBlank).findFirst();
    if (identifer.isPresent()) {
      var prefix = getResourceTypePrefix(resource);
      if (prefix != null) {
        return prefix + identifer.get();
      }
    }

    return null;
  }

  /**
   * Queries HAPI FHIR MDM for the golden resource ID
   *
   * @param logicalId the full id of the resource
   * @param treatPossibleMatchesAsMatch
   * @return
   */
  public String getGoldenResourceByFhirLogicalId(
      String logicalId,
      String resourceType,
      boolean treatPossibleMatchesAsMatch,
      IGenericClient client) {

    var matcher = uuidRegex.matcher(logicalId);
    if (!matcher.find()) {
      return null;
    }
    var fhirId = resourceType + "/" + matcher.group();
    log.info("Finding matches for {}", fhirId);

    // Query for links with this id
    Parameters response;
    try {
      response =
          client
              .operation()
              .onServer()
              .named("$mdm-query-links")
              .withParameter(Parameters.class, "resourceId", new StringType(fhirId))
              .execute();
    } catch (InvalidRequestException e) {
      log.error("Invalid request with resource ID: {}", fhirId);
      return logicalId;
    }

    // Get the link param lists
    List<List<Parameters.ParametersParameterComponent>> links =
        response.getParameter().stream()
            .filter(param -> param.getName().equals("link"))
            .map(
                linkParams -> {
                  return linkParams.getPart();
                })
            .toList();

    // Find the link with MATCH or POSSIBLE_MATCH
    for (List<Parameters.ParametersParameterComponent> link : links) {
      Optional<String> goldenResourceId =
          getGoldenResourceFromLink(link, treatPossibleMatchesAsMatch);
      if (goldenResourceId.isPresent()) {
        return goldenResourceId
            .get()
            .replaceFirst(resourceType + "/", getResourceTypePrefix(resourceType));
      }
    }

    // If we did not find a MATCH then we return the same ID
    return logicalId;
  }

  private Optional<String> getGoldenResourceFromLink(
      List<Parameters.ParametersParameterComponent> link, boolean treatPossibleMatchesAsMatch) {
    for (Parameters.ParametersParameterComponent param : link) {
      if (param.getName().equals("matchResult")) {
        String value = param.getValue().toString();
        if (value.equals("MATCH")
            || (treatPossibleMatchesAsMatch && value.equals("POSSIBLE_MATCH"))) {
          String goldenResourceId =
              link.stream()
                  .filter(p -> p.getName().equals("goldenResourceId"))
                  .findFirst()
                  .get()
                  .getValue()
                  .toString();
          return Optional.of(goldenResourceId);
        } else {
          return Optional.empty();
        }
      }
    }

    return Optional.empty();
  }
}
