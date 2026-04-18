// lib/core/usecases/usecase.dart

import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// All use cases implement this contract.
/// [Type] = success return type
/// [Params] = input data class (use [NoParams] when none needed)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used for use cases that require no input.
class NoParams {
  const NoParams();
}
