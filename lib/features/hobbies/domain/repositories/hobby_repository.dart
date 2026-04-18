import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/hobby.dart';

abstract class HobbyRepository {
  Future<Either<Failure, List<Hobby>>> getHobbies();
  Future<Either<Failure, Hobby>> getHobbyById(String id);
  Future<Either<Failure, void>> addHobby(Hobby hobby);
  Future<Either<Failure, void>> updateHobby(Hobby hobby);
  Future<Either<Failure, void>> deleteHobby(String id);
}
