/* External dependencies */
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test_work_mbank/features/manufacturers/data/models/manufacturer_model.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/logic/bloc/manufacture_bloc.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/screens/manufaturer_detail_screen.dart';
import 'package:test_work_mbank/features/manufacturers/presentation/screens/manufaturer_main_screen.dart';

class MockManufactureBloc extends MockBloc<ManufactureEvent, ManufactureState>
    implements ManufactureBloc {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  ManufactureBloc blockForTest = MockManufactureBloc();
  final mockObserver = MockNavigatorObserver();

  group(
    'MainScreen',
    () {
      testWidgets(
        'should find the MainScreen widgets when loading',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturesLoadingState(),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: MainScreen(
                blocForTest: blockForTest,
              ),
            ),
          );

          await tester.pump();

          expect(find.byType(MainScreen), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        },
      );

      testWidgets(
        'should find the MainScreen widgets when error',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturesErrorState(),
          );

          await tester.pumpWidget(
            MaterialApp(
              home: MainScreen(
                blocForTest: blockForTest,
              ),
            ),
          );

          await tester.pump();

          expect(find.byType(MainScreen), findsOneWidget);
          expect(find.text("Error"), findsOneWidget);
        },
      );

      testWidgets(
        'should find the MainScreen widgets when fetchedState',
        (WidgetTester tester) async {
          when(() => blockForTest.state).thenAnswer(
            (_) => ManufacturesFetchedState(listOfManufacterModel: const []),
          );
          await tester.pumpWidget(
            MaterialApp(
              home: MainScreen(
                blocForTest: blockForTest,
              ),
            ),
          );

          await tester.pump();

          expect(find.byType(MainScreen), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsNothing);
          expect(find.byType(ListView), findsOneWidget);
        },
      );

      testWidgets(
        'should find the MainScreen widgets when fetchedState and tap card',
        (WidgetTester tester) async {
          whenListen(
            blockForTest,
            Stream<ManufactureState>.fromIterable([
              ManufactureInitial(),
              ManufacturesFetchedState(
                listOfManufacterModel: [
                  ManufacterModel(
                    country: "country",
                    mfrCommonName: "mfrCommonName",
                    mfrId: 1,
                    mfrName: "mfrName",
                  )
                ],
              )
            ]),
            initialState: ManufactureInitial(),
          );
          await tester.pumpWidget(
            MaterialApp(
              navigatorObservers: [mockObserver],
              home: MainScreen(
                blocForTest: blockForTest,
              ),
            ),
          );

          await tester.pump();
          await tester.tap(find.byType(ListTile));
          await tester.pumpAndSettle();

          expect(find.byType(ManufaturerDetailScreen), findsOneWidget);
        },
      );
    },
  );
}
