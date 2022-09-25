class CurrentUser {
  final String email;
  final int points;
  final String username;

  const CurrentUser({
    required this.email,
    required this.points,
    required this.username,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      email: json['email'],
      points: json['points'],
      username: json['username'],
    );
  }
}
