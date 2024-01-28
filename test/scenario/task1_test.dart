import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_player_trainee/config/themes/main_color.dart';
import 'package:media_player_trainee/constants/assets_const.dart';
import 'package:media_player_trainee/features/splash/components/circle_component.dart';
import 'package:media_player_trainee/features/splash/splash_screen.dart';

void task1Test() {
  testWidgets('Structure of the Circle Component widget is built correctly',
      (WidgetTester tester) async {
    // Create the widget with default values
    const double scale = 1.5;
    await tester.pumpWidget(const CircleComponent(scale: scale));

    // Find the CircleComponent in the widget tree
    final circle = find.byType(CircleComponent);
    expect(circle, findsOneWidget);

    // Assert the ClipRRect and Transform.scale properties
    final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
    expect(clipRRect.child, isA<Transform>());
    final transform = clipRRect.child as Transform;
    expect(
      transform.transform,
      Matrix4.diagonal3Values(scale, scale, 1),
    );

    // Assert the default Container child
    final container = transform.child as Container;
    expect(container.decoration, isA<BoxDecoration>());
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.shape, equals(BoxShape.circle));
    expect(decoration.color, isNull);
  });

  testWidgets('CircleComponent renders with color',
      (WidgetTester tester) async {
    const color = Colors.blue;
    await tester.pumpWidget(const CircleComponent(scale: 2.0, color: color));

    final container = tester.widget<Container>(find.byType(Container));
    expect((container.decoration as BoxDecoration).color, color);
  });

  testWidgets('CircleComponent renders with child',
      (WidgetTester tester) async {
    final child = Container(
      key: const Key('child_test'),
    );
    await tester.pumpWidget(CircleComponent(
      scale: 1.2,
      child: child,
    ));

    find.byWidgetPredicate((widget) =>
        widget.key == const Key('child_test') && widget is Container);
  });

  group('Splash screen built to specifications', () {
    final routes = <String, WidgetBuilder>{
      '/home': (_) => const Scaffold(
            body: Text('Home Screen'),
          ),
    };
    testWidgets('has animated opacity with circle component',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      // Verify widget structure
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
      expect(find.byType(AnimatedOpacity), findsNWidgets(5));
      expect(find.byType(CircleComponent), findsNWidgets(5));

      // Initially, all circles should be invisible
      for (int i = 0; i < 5; i++) {
        expect(
            (find.byType(AnimatedOpacity).at(i).evaluate().single.widget
                    as AnimatedOpacity)
                .opacity,
            0);
      }

      // verify circle atribut
      final colors = [
        MainColor.grey989794,
        MainColor.greyB6B5B1,
        MainColor.greyD4D2CE,
        MainColor.black222222,
      ];
      final scales = [3, 1.7, 1.3, 0.8];

      for (var i = 0; i < 4; i++) {
        find.byWidgetPredicate(
          (widget) =>
              widget is CircleComponent &&
              widget.key == Key('circle_${i + 1}') &&
              widget.scale == scales[i] &&
              widget.color == colors[i],
        );
      }
      find.byWidgetPredicate(
        (widget) =>
            widget is CircleComponent &&
            widget.key == const Key('circle_5') &&
            widget.scale == scales[3],
      );

      // Trigger animation completion
      await tester.pump(const Duration(milliseconds: 1800));
      // Initially, all circles should be invisible
      for (int i = 0; i < 5; i++) {
        expect(
            (find.byType(AnimatedOpacity).at(i).evaluate().single.widget
                    as AnimatedOpacity)
                .opacity,
            1);
      }
      await tester.pumpAndSettle();
    });

    testWidgets('display the logo using svg', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      find.byWidgetPredicate(
        (widget) =>
            widget is CircleComponent &&
            widget.key == const Key('circle_5') &&
            widget.child is SvgPicture,
      );
      final svgPictureFinder = find.byType(SvgPicture);
      expect(svgPictureFinder, findsOneWidget);
      expect(
        tester.widget<SvgPicture>(svgPictureFinder).bytesLoader,
        const SvgAssetLoader(
          AssetsConsts.logo,
        ),
      );

      // Trigger animation completion
      await tester.pumpAndSettle(const Duration(milliseconds: 2200));
    });

    testWidgets('navigate to home screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const SplashScreen(),
        routes: routes,
      ));

      // Trigger animation and navigatin completion
      await tester.pumpAndSettle(const Duration(milliseconds: 2200));

      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });
  });
}
