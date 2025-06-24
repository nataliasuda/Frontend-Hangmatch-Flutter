class User {
  final String id;
  final String name;
  final String email;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });
}

class Register {
  final String name;
  final String email;
  final String password;
  final String repeatPassword;

  Register({
    required this.name,
    required this.email,
    required this.password,
    required this.repeatPassword,
  });
}
class Login {
  final String email;
  final String password;

  Login({

    required this.email,
    required this.password,
  });

}