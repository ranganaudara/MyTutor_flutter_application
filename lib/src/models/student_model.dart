class Student {
  String name;
  String mobile;
  String location;
  String email;
  int status;

  Student(
    this.name,
    this.mobile,
    this.location,
    this.email,
    this.status,
  );

  Student.fromJson(Map<String, dynamic> parsedJson) {
    this.name = parsedJson["user"]["name"];
    this.mobile = parsedJson["user"]["mobile"];
    this.location = parsedJson["user"]["location"];
    this.email = parsedJson["user"]["email"];
    this.status = parsedJson["user"]["status"];
  }
}
