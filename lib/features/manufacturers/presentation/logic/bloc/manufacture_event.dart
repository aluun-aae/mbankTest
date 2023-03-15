part of 'manufacture_bloc.dart';

@immutable
abstract class ManufactureEvent {}

class GetManufacturesEvent extends ManufactureEvent {
  final int page;

  GetManufacturesEvent({required this.page});
}

class GetManufacturerDetailEvent extends ManufactureEvent {
  final String markName;

  GetManufacturerDetailEvent({required this.markName});
}
