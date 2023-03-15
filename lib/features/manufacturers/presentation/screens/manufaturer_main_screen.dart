import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/manufacturer_model.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/screens/manufaturer_detail_screen.dart';

import '../../data/repositories/manufacturer_repository_impl.dart';
import '../../domain/use_case/manufacturer_use_case.dart';
import '../logic/bloc/manufacture_bloc.dart';

class MainScreen extends StatefulWidget {
  final ManufactureBloc? blocForTest;
  const MainScreen({
    super.key,
    this.blocForTest,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;
  List<ManufacterModel> listOfManufacterModel = [];
  bool isLoadingMore = false;

  late ManufactureBloc _bloc;

  @override
  void initState() {
    _bloc = widget.blocForTest ??
        ManufactureBloc(ManufacturerUseCase(ManufacturerRepositoryImpl()));
    _scrollController.addListener(
      () {
        if (isLoadingMore) return;
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          currentPage = currentPage + 1;
          log(currentPage.toString());
          _bloc.add(GetManufacturesEvent(page: currentPage));
        }
      },
    );
    _bloc.add(GetManufacturesEvent(page: currentPage));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manufaturers list"),
      ),
      body: BlocConsumer<ManufactureBloc, ManufactureState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is ManufacturesFetchedState) {
            isLoadingMore = false;
            listOfManufacterModel = state.listOfManufacterModel;
          }
          if (state is ManufacturesLoadingMoreState) {
            isLoadingMore = true;
          }
        },
        builder: (context, state) {
          log(listOfManufacterModel.length.toString());
          if (state is ManufacturesLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManufacturesErrorState) {
            return const Center(
              child: Text("Error"),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listOfManufacterModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(5),
                      child: ListTile(
                          dense: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Provider(
                                  create: (context) =>
                                      listOfManufacterModel[index],
                                  child: ManufaturerDetailScreen(
                                      blocForTest: widget.blocForTest),
                                ),
                              ),
                            );
                          },
                          leading: Text(
                            listOfManufacterModel[index].mfrId.toString(),
                          ),
                          title: Text(
                            listOfManufacterModel[index].country,
                          ),
                          subtitle: Text(
                            listOfManufacterModel[index].mfrName,
                          )),
                    );
                  },
                ),
              ),
              isLoadingMore ? const Text("Loading") : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
