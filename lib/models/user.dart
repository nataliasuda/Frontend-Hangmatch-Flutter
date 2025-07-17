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

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      repeatPassword: json['repeatPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'repeatPassword': repeatPassword,
    };
  }
}

class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
