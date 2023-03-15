import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_work_mbank/features/manufacturers/data/repositories/manufacturer_repository_impl.dart';
import 'package:test_work_mbank/features/manufacturers/domain/use_case/manufacturer_use_case.dart';

import '../../../data/models/makes_model.dart';
import '../../../data/models/manufacturer_model.dart';

part 'manufacture_event.dart';
part 'manufacture_state.dart';

class ManufactureBloc extends Bloc<ManufactureEvent, ManufactureState> {
  final ManufacturerUseCase useCase;
  ManufactureBloc(this.useCase) : super(ManufactureInitial()) {
    on<GetManufacturesEvent>(
      (event, emit) async {
        event.page > 1
            ? emit(ManufacturesLoadingMoreState())
            : emit(ManufacturesLoadingState());

        await useCase.getManufactures(event.page).then(
          (value) {
            emit(
              ManufacturesFetchedState(listOfManufacterModel: value),
            );
          },
        ).onError(
          (error, stackTrace) {
            emit(ManufacturesErrorState());
          },
        );
      },
    );

    on<GetManufacturerDetailEvent>(
      (event, emit) async {
        emit(ManufacturesLoadingState());
        await useCase.getManufacturerDetail(event.markName).then(
          (value) {
            emit(
              ManufacturerMakesFetchedState(
                listOfMakesModel: value,
              ),
            );
          },
        ).onError(
          (error, stackTrace) {
            log(error.toString());
            emit(ManufacturesErrorState());
          },
        );
      },
    );
  }
}
