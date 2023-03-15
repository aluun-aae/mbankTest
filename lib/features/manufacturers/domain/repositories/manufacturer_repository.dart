import '../../data/models/makes_model.dart';
import '../../data/models/manufacturer_model.dart';

abstract class ManufacturerRepository {
  Future<List<ManufacterModel>> getManufactures(int page);
  Future<List<MakesModel>> getManufacturerDetail(String markName);
}
