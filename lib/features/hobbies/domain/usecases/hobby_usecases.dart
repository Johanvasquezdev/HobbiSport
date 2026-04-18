import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/hobby.dart';
import '../repositories/hobby_repository.dart';

class GetHobbies implements UseCase<List<Hobby>, NoParams> {
  GetHobbies(this.repository);

  final HobbyRepository repository;

  @override
  Future<Either<Failure, List<Hobby>>> call(NoParams params) {
    return repository.getHobbies();
  }
}

class AddHobbyParams {
  const AddHobbyParams({
    required this.name,
    required this.category,
    required this.description,
    required this.emoji,
    required this.userId,
  });

  final String name;
  final String category;
  final String description;
  final String emoji;
  final String userId;
}

class AddHobby implements UseCase<void, AddHobbyParams> {
  AddHobby(this.repository, this._uuid);

  final HobbyRepository repository;
  final Uuid _uuid;

  @override
  Future<Either<Failure, void>> call(AddHobbyParams params) {
    final hobby = Hobby(
      id: _uuid.v4(),
      name: params.name,
      category: params.category,
      description: params.description,
      emoji: params.emoji,
      userId: params.userId,
      createdAt: DateTime.now(),
    );
    return repository.addHobby(hobby);
  }
}

class UpdateHobby implements UseCase<void, Hobby> {
  UpdateHobby(this.repository);

  final HobbyRepository repository;

  @override
  Future<Either<Failure, void>> call(Hobby params) {
    return repository.updateHobby(params);
  }
}

class DeleteHobby implements UseCase<void, String> {
  DeleteHobby(this.repository);

  final HobbyRepository repository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return repository.deleteHobby(params);
  }
}
