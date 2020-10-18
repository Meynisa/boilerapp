class LoginResponse {

  String tokenType;
  int expiresIn;
  String accessToken;
  String refreshToken;

  LoginResponse(
      {this.tokenType,
        this.expiresIn,
        this.accessToken,
        this.refreshToken});

  LoginResponse.fromJson(Map<String, dynamic> map):
        tokenType = map["token_type"],
        expiresIn = map["expires_in"],
        accessToken = map["access_token"],
        refreshToken = map["refresh_token"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
