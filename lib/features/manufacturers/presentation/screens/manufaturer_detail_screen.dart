import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:test_work_mbank/features/manufacturers/domain/use_case/manufacturer_use_case.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/logic/bloc/manufacture_bloc.dart';

import '../../data/models/manufacturer_model.dart';
import '../../data/repositories/manufacturer_repository_impl.dart';

class ManufaturerDetailScreen extends StatefulWidget {
  final ManufactureBloc? blocForTest;
  const ManufaturerDetailScreen({super.key, this.blocForTest});

  @override
  State<ManufaturerDetailScreen> createState() =>
      _ManufaturerDetailScreenState();
}

class _ManufaturerDetailScreenState extends State<ManufaturerDetailScreen> {
  late ManufactureBloc _bloc;

  @override
  void initState() {
    _bloc = widget.blocForTest ??
        ManufactureBloc(ManufacturerUseCase(ManufacturerRepositoryImpl()));

    _bloc.add(
      GetManufacturerDetailEvent(
        markName: context
            .read<ManufacterModel>()
            .mfrName
            .split(" ")
            .first
            .replaceAll(
              RegExp('[^a-zA-Z]'),
              '',
            )
            .toLowerCase(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manufaturer detail screen"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              context.read<ManufacterModel>().mfrName,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: BlocBuilder<ManufactureBloc, ManufactureState>(
              bloc: _bloc,
              builder: (context, state) {
                if (state is ManufacturesLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ManufacturesErrorState) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                if (state is ManufacturerMakesFetchedState) {
                  return ListView.builder(
                    itemCount: state.listOfMakesModel.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            state.listOfMakesModel[index].modelName!,
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
