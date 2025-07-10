class ChangePasswordDto {
  final int userId;
  final String currentPassword;
  final String newPassword;

  ChangePasswordDto({
    required this.userId,
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "currentPassword": currentPassword,
    "newPassword": newPassword,
  };
}
