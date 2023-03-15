import 'package:test_work_mbank/features/manufacturers/data/models/makes_model.dart';

import '../../data/models/manufacturer_model.dart';
import '../../data/repositories/manufacturer_repository_impl.dart';

class ManufacturerUseCase {
  ManufacturerUseCase(
    this.manufacturerRepository,
  );
  final ManufacturerRepositoryImpl manufacturerRepository;

  Future<List<ManufacterModel>> getManufactures(int page) async =>
      await manufacturerRepository.getManufactures(page);
  Future<List<MakesModel>> getManufacturerDetail(String markName) async =>
      await manufacturerRepository.getManufacturerDetail(markName);
}
