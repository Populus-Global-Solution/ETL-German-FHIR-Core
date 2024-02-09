package org.miracum.etl.fhirtoomop.interceptors;

public class SimpleKeycloakAccessToken {
  private String access_token;
  private Integer expires_in;
  private Integer refresh_expires_in;
  private String token_type;
  private String notBeforePolicy;
  private String scope;
  private long requestTimeMillis;

  public SimpleKeycloakAccessToken() {
    this.requestTimeMillis = System.currentTimeMillis();
  }

  public String getAccess_token() {
    return access_token;
  }

  public void setAccess_token(String access_token) {
    this.access_token = access_token;
  }

  public Integer getExpires_in() {
    return expires_in;
  }

  public void setExpires_in(Integer expires_in) {
    this.expires_in = expires_in;
  }

  public Integer getRefresh_expires_in() {
    return refresh_expires_in;
  }

  public void setRefresh_expires_in(Integer refresh_expires_in) {
    this.refresh_expires_in = refresh_expires_in;
  }

  public String getToken_type() {
    return token_type;
  }

  public void setToken_type(String token_type) {
    this.token_type = token_type;
  }

  public String getNotBeforePolicy() {
    return notBeforePolicy;
  }

  public void setNotBeforePolicy(String notBeforePolicy) {
    this.notBeforePolicy = notBeforePolicy;
  }

  public String getScope() {
    return scope;
  }

  public void setScope(String scope) {
    this.scope = scope;
  }

  public boolean isExpired(Integer minValidityBuffer) {
    if (this.expires_in == null) {
      return false;
    }
    if (minValidityBuffer == null) {
      minValidityBuffer = 20;
    }
    long tokenValidityWindowInMillis = (this.expires_in - minValidityBuffer) * 1000L;
    return System.currentTimeMillis() > this.requestTimeMillis + tokenValidityWindowInMillis;
  }
}
