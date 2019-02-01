class Student {
  String name;
  String mobile;
  String location;
  String email;
  String image;

  Student(
    this.name,
    this.mobile,
    this.location,
    this.email,
    this.image,
  );

  Student.fromJson(Map<String, dynamic> parsedJson) {
    this.name = parsedJson["profile"]["name"];
    this.mobile = parsedJson["profile"]["mobile"];
    this.location = parsedJson["profile"]["location"];
    this.email = parsedJson["profile"]["email"];
    this.image = parsedJson["profile"]["status"];
  }
}
