package org.miracum.etl.fhirtoomop.interceptors;

import ca.uhn.fhir.rest.client.api.IHttpRequest;
import ca.uhn.fhir.rest.client.interceptor.BearerTokenAuthInterceptor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

@Slf4j
public class ClientCredentialsInterceptor extends BearerTokenAuthInterceptor {
  public static final String GRANT_TYPE = "grant_type";
  public static final String CLIENT_ID = "client_id";
  public static final String CLIENT_SECRET = "client_secret";
  public static final String CLIENT_CREDENTIALS = "client_credentials";

  private SimpleKeycloakAccessToken currentToken;
  private String tokenUrl;
  private String clientId;
  private String clientSecret;
  private Integer tokenMinValidityBuffer;

  public ClientCredentialsInterceptor(
      String clientId, String secret, String tokenUrlIn, Integer tokenMinValidityBuffer) {
    this.clientId = clientId;
    this.clientSecret = secret;
    this.tokenUrl = tokenUrlIn;
    this.tokenMinValidityBuffer = tokenMinValidityBuffer;
  }

  @Override
  public void interceptRequest(IHttpRequest theRequest) {
    verifyOrRefreshToken();
    super.interceptRequest(theRequest);
  }

  private void verifyOrRefreshToken() {
    if (StringUtils.isBlank(getToken()) || this.currentToken.isExpired(tokenMinValidityBuffer)) {
      RestTemplate restTemplate = new RestTemplate();

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

      MultiValueMap<String, String> map = new LinkedMultiValueMap<>();

      map.add(GRANT_TYPE, CLIENT_CREDENTIALS);
      map.add(CLIENT_ID, clientId);
      map.add(CLIENT_SECRET, clientSecret);

      HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

      try {
        ResponseEntity<SimpleKeycloakAccessToken> responseEntity =
            restTemplate.exchange(
                tokenUrl, HttpMethod.POST, entity, SimpleKeycloakAccessToken.class);
        if (!responseEntity.getStatusCode().equals(HttpStatus.OK)) {
          ResponseStatusException responseStatusException =
              new ResponseStatusException(
                  HttpStatus.valueOf(responseEntity.getStatusCodeValue()),
                  "Request failed with status code " + responseEntity.getStatusCode());
          log.error("Token Request failed", responseStatusException);
          throw responseStatusException;
        }
        this.currentToken = responseEntity.getBody();
        if (this.currentToken != null) {
          setToken(this.currentToken.getAccess_token());
        }
      } catch (RestClientException exc) {
        ResponseStatusException responseStatusException =
            new ResponseStatusException(
                HttpStatus.INTERNAL_SERVER_ERROR,
                "An error occurred while making the request",
                exc);
        log.error("Token Request failed", responseStatusException);
        throw responseStatusException;
      }
    }
  }
}
