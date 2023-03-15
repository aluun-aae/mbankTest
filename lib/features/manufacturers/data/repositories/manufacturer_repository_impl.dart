import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/makes_model.dart';

import '../../../../internal/helpers/api_requester.dart';
import '../../domain/repositories/manufacturer_repository.dart';
import '../../../../internal/helpers/local_storage/manufacturer_storage.dart';
import '../models/manufacturer_model.dart';

class ManufacturerRepositoryImpl implements ManufacturerRepository {
  final apiRequester = APIRequester();
  bool lastResponceIsEmpty = false;
  List<ManufacterModel> listOfManufacterModels = [];

  @override
  Future<List<ManufacterModel>> getManufactures(int page) async {
    try {
      final response = await apiRequester.toGet(
        '/vehicles/getallmanufacturers',
        queryParameters: {
          'format': "json",
          'page': page,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        if (response.data["Count"] != 0) {
          response.data["Results"].forEach(
            (e) async {
              if (e != null) {
                listOfManufacterModels.add(ManufacterModel.fromJson(e));
                await SQLHelper.deleteManufacturerItem(e['Mfr_ID']);
                await SQLHelper.createManufacterItem(
                  ManufacterModel.fromJson(e),
                );
              }
            },
          );
        }

        return listOfManufacterModels;
      }

      throw Error();
    } catch (err) {
      listOfManufacterModels = await SQLHelper.getManufacterItems();
      if (listOfManufacterModels.isNotEmpty) {
        return listOfManufacterModels;
      }
      log(err.toString());
      rethrow;
    }
  }

  @override
  Future<List<MakesModel>> getManufacturerDetail(String markName) async {
    List<MakesModel> listOfMakesModel = [];

    try {
      final response = await apiRequester.toGet(
        '/vehicles/getmodelsformake/$markName',
        queryParameters: {
          'format': "json",
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        response.data["Results"].forEach(
          (e) async {
            if (e != null) {
              listOfMakesModel.add(MakesModel.fromJson(e));

              await SQLHelper.deleteMakesItem(e['Model_Name']);
              await SQLHelper.createMakesItem(MakesModel.fromJson(e));
            }
          },
        );
        log(listOfMakesModel[0].toString());
        return listOfMakesModel;
      }
      log("123 ${response.statusMessage}");
      throw Error();
    } catch (err) {
      listOfMakesModel = await SQLHelper.getMakesItems(markName);
      if (listOfMakesModel.isNotEmpty) {
        return listOfMakesModel;
      }
      rethrow;
    }
  }
}
