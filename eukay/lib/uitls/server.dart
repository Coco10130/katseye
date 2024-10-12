class Server {
  // api server url
  static const serverUrl = "http://192.168.43.96:8080";

  //! PSGC public api urls
  // server url for municipalities of pangasinan
  static const pangasinanMunicipalities =
      "https://psgc.cloud/api/provinces/0105500000/cities-municipalities";

  // server url for barangay
  static String municipalityBarangays(String municipalityCode) {
    return "https://psgc.cloud/api/cities-municipalities/$municipalityCode/barangays";
  }
}
