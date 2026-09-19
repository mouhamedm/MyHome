import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myhouse/main.dart';
import 'package:myhouse/data/property_repository.dart';
import 'package:myhouse/features/property_detail/screens/property_detail_screen.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getUrl || invocation.memberName == #openUrl) {
      return Future.value(_MockHttpClientRequest());
    }
    return null;
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #close) {
      return Future.value(_MockHttpClientResponse());
    }
    return null;
  }
}

class _MockHttpClientResponse implements HttpClientResponse {
  static final Uint8List _transparentPng = Uint8List.fromList([
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([_transparentPng]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  Widget createTestApp({Widget? child}) {
    return MediaQuery(
      data: const MediaQueryData(size: Size(420, 900)),
      child: child ?? const MyHouseApp(),
    );
  }

  testWidgets('MyHouseApp smoke test and navigation verification', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420 * 2.0, 900 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(createTestApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Brand elements
    expect(find.text('MY'), findsOneWidget);
    expect(find.text('HOUSE'), findsOneWidget);
    expect(find.text('Explorer les espaces'), findsOneWidget);

    // Verify navigation to Search via bottom bar icon
    await tester.tap(find.byIcon(Icons.search_rounded).last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byIcon(Icons.view_agenda_outlined), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsOneWidget);
    expect(find.byIcon(Icons.map_outlined), findsOneWidget);

    // Switch to Grid Mode
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Grille'), findsOneWidget);

    // Verify navigation to Saved tab
    await tester.tap(find.byIcon(Icons.favorite_outline_rounded).last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Propriétés sauvegardées'), findsOneWidget);

    // Verify navigation to Profile tab
    await tester.tap(find.byIcon(Icons.person_outline_rounded).last);
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Mouhamed'), findsOneWidget);
    expect(find.text('Paris, France'), findsOneWidget);
  });

  testWidgets('Property detail screen renders complete luxury information', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(420 * 2.0, 900 * 2.0);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final prop = PropertyRepository.instance.allProperties.first;

    await tester.pumpWidget(
      MaterialApp(
        home: PropertyDetailScreen(propertyId: prop.id),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(prop.title), findsOneWidget);
    expect(find.text('À propos de ce bien'), findsOneWidget);
    expect(find.text('Équipements & Prestations'), findsOneWidget);
    expect(find.text("Contacter l'agent"), findsOneWidget);
  });
}
