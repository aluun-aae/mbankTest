part of 'manufacture_bloc.dart';

@immutable
abstract class ManufactureState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ManufactureInitial extends ManufactureState {}

class ManufacturesLoadingState extends ManufactureState {}

class ManufacturesLoadingMoreState extends ManufactureState {}

class ManufacturesErrorState extends ManufactureState {}

class ManufacturesFetchedState extends ManufactureState {
  final List<ManufacterModel> listOfManufacterModel;

  ManufacturesFetchedState({
    required this.listOfManufacterModel,
  });
  @override
  List<Object?> get props => [listOfManufacterModel];
}

class ManufacturerMakesFetchedState extends ManufactureState {
  final List<MakesModel> listOfMakesModel;

  ManufacturerMakesFetchedState({
    required this.listOfMakesModel,
  });
  @override
  List<Object?> get props => [listOfMakesModel];
}
