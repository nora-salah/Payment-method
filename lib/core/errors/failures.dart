abstract class Failure {
  final String errorMessage;

  Failure({required this.errorMessage}); // Failure
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage}); // ServerFailure
}
