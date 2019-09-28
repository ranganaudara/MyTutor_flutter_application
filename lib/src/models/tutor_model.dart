class Tutor {
  String fname;
  String lname;
  String email;
  String location;
  String mobile;
  String subject;
  String imgUrl;
  var rating;
  String available;
  var price;
  String description;

  Tutor(
    this.fname,
    this.lname,
    this.email,
    this.location,
    this.mobile,
    this.subject,
    this.imgUrl,
    this.rating,
    this.available,
    this.description,
    this.price,
  );

  Tutor.fromJson(Map<String, dynamic> parsedJson) {
    this.email = parsedJson['profile']['email'];
    this.fname = parsedJson['profile']['firstName'];
    this.lname = parsedJson['profile']['lastName'];
    this.description = parsedJson['profile']['description'];
    this.location = parsedJson['profile']['location'];
    this.mobile = parsedJson['profile']['mobile'];
    this.subject = parsedJson['profile']['subject'];
    this.rating = parsedJson['profile']['rate'];
    this.imgUrl = parsedJson['profile']['imgUrl'];
    this.price = parsedJson['profile']['price'];
    this.available = parsedJson['profile']['available'];
  }
}
