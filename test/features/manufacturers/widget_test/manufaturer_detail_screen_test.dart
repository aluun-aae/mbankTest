/* External dependencies */
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/manufacturer_model.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/logic/bloc/manufacture_bloc.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/screens/manufaturer_detail_screen.dart';

class MockManufactureBloc extends MockBloc<ManufactureEvent, ManufactureState>
    implements ManufactureBloc {}

void main() {
  ManufactureBloc blockForTest = MockManufactureBloc();

  group(
    'ManufaturerDetailScreen',
    () {
      testWidgets(
        'should find the ManufaturerDetailScreen widgets when loading',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturesLoadingState(),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Provider(
                create: (_) => ManufacterModel(
                  country: "country",
                  mfrCommonName: "mfrCommonName",
                  mfrId: 1,
                  mfrName: "mfrName",
                ),
                child: ManufaturerDetailScreen(blocForTest: blockForTest),
              ),
            ),
          );

          await tester.pump();

          expect(find.text("mfrName"), findsOneWidget);
          expect(find.byType(ManufaturerDetailScreen), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'should find the ManufaturerDetailScreen widgets when error',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturesErrorState(),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: Provider(
                create: (_) => ManufacterModel(
                  country: "country",
                  mfrCommonName: "mfrCommonName",
                  mfrId: 1,
                  mfrName: "mfrName",
                ),
                child: ManufaturerDetailScreen(blocForTest: blockForTest),
              ),
            ),
          );

          await tester.pump();

          expect(find.text("mfrName"), findsOneWidget);
          expect(find.byType(ManufaturerDetailScreen), findsOneWidget);
          expect(find.text("Error"), findsOneWidget);
        },
      );

      testWidgets(
        'should find the ManufaturerDetailScreen widgets when fetchedState',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturerMakesFetchedState(listOfMakesModel: const []),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: Provider(
                create: (_) => ManufacterModel(
                  country: "country",
                  mfrCommonName: "mfrCommonName",
                  mfrId: 1,
                  mfrName: "mfrName",
                ),
                child: ManufaturerDetailScreen(blocForTest: blockForTest),
              ),
            ),
          );

          await tester.pump();

          expect(find.text("mfrName"), findsOneWidget);
          expect(find.byType(ManufaturerDetailScreen), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.byType(ListView), findsOneWidget);
        },
      );
    },
  );
}
