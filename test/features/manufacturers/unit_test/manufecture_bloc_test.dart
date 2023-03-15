/* External dependencies */
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/makes_model.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/manufacturer_model.dart';
import 'package:test_work_mbank/features/manufacturers/data/repositories/manufacturer_repository_impl.dart';
import 'package:test_work_mbank/features/manufacturers/domain/use_case/manufacturer_use_case.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/logic/bloc/manufacture_bloc.dart';

class MockManufacturerRepositoryImpl extends Mock
    implements ManufacturerRepositoryImpl {}

void main() {
  List<ManufacterModel> listOfManufacterModel = [];
  List<MakesModel> listOfMakesModel = [];
  ManufacturerRepositoryImpl manufacturerRepository =
      MockManufacturerRepositoryImpl();
  group(
    'ManufactureBloc',
    () {
      blocTest<ManufactureBloc, ManufactureState>(
        'emits ManufacturesFetchedState when GetManufacturesEvent',
        build: () =>
            ManufactureBloc(ManufacturerUseCase(manufacturerRepository)),
        act: (bloc) {
          when(() => manufacturerRepository.getManufactures(any()))
              .thenAnswer((_) => Future.value(listOfManufacterModel));
          bloc.add(
            GetManufacturesEvent(page: 1),
          );
        },
        expect: () => [
          isA<ManufacturesLoadingState>(),
          ManufacturesFetchedState(listOfManufacterModel: listOfManufacterModel)
        ],
      );

      blocTest<ManufactureBloc, ManufactureState>(
        'emits ErrorState when GetManufacturesEvent',
        build: () =>
            ManufactureBloc(ManufacturerUseCase(manufacturerRepository)),
        act: (bloc) {
          when(() => manufacturerRepository.getManufactures(any()))
              .thenThrow((_) => Error());
          bloc.add(
            GetManufacturesEvent(page: 1),
          );
        },
        expect: () =>
            [isA<ManufacturesLoadingState>(), ManufacturesErrorState()],
      );

      blocTest<ManufactureBloc, ManufactureState>(
        'emits ManufacturerMakesFetchedState when GetManufacturerDetailEvent',
        build: () =>
            ManufactureBloc(ManufacturerUseCase(manufacturerRepository)),
        act: (bloc) {
          when(() => manufacturerRepository.getManufacturerDetail(any()))
              .thenAnswer((_) => Future.value(listOfMakesModel));
          bloc.add(
            GetManufacturerDetailEvent(markName: "tesla"),
          );
        },
        expect: () => [
          isA<ManufacturesLoadingState>(),
          ManufacturerMakesFetchedState(listOfMakesModel: listOfMakesModel)
        ],
      );

      blocTest<ManufactureBloc, ManufactureState>(
        'emits ErrorState when GetManufacturerDetailEvent',
        build: () =>
            ManufactureBloc(ManufacturerUseCase(manufacturerRepository)),
        act: (bloc) {
          when(() => manufacturerRepository.getManufacturerDetail(any()))
              .thenThrow((_) => Error());
          bloc.add(
            GetManufacturerDetailEvent(markName: "tesla"),
          );
        },
        expect: () =>
            [isA<ManufacturesLoadingState>(), ManufacturesErrorState()],
      );
    },
  );
}
