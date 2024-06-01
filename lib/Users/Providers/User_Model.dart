class User_Model {
  final int id;
  final String first_name;
  final String last_name;
  final String phone_number;
  final String email;
  final String region;
  final double longitude;
  final double latitude;
  final String status;
  final String profile_pic;

  User_Model({
    required this.id,
    required this.longitude,
    required this.region,
    required this.latitude,
    required this.phone_number,
    required this.email,
    required this.status,
    required this.last_name,
    required this.first_name,
    required this.profile_pic,
  });
}
