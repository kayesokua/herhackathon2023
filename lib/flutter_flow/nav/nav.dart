import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import '../flutter_flow_theme.dart';

import '../../index.dart';
import '../../main.dart';
import '../lat_lng.dart';
import '../place.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Center(
                  child: Image.asset(
                    'assets/images/freudenberg_group_logo.png',
                    width: MediaQuery.sizeOf(context).width * 0.15,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            )
          : WelcomePageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Image.asset(
                        'assets/images/freudenberg_group_logo.png',
                        width: MediaQuery.sizeOf(context).width * 0.15,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                )
              : WelcomePageWidget(),
          routes: [
            FFRoute(
              name: 'WelcomePage',
              path: 'welcomePage',
              builder: (context, params) => WelcomePageWidget(),
            ),
            FFRoute(
              name: 'VerifyEmployee',
              path: 'verifyEmployee',
              builder: (context, params) => VerifyEmployeeWidget(),
            ),
            FFRoute(
              name: 'verifyAccount',
              path: 'verifyAccount',
              builder: (context, params) => VerifyAccountWidget(),
            ),
            FFRoute(
              name: 'EnableFingerprint',
              path: 'enableFingerprint',
              builder: (context, params) => EnableFingerprintWidget(),
            ),
            FFRoute(
              name: 'userAddress',
              path: 'userAddress',
              builder: (context, params) => UserAddressWidget(),
            ),
            FFRoute(
              name: 'userPreference3',
              path: 'userHobbies',
              builder: (context, params) => UserPreference3Widget(),
            ),
            FFRoute(
              name: 'MyCredits',
              path: 'MyCredits',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'MyCredits')
                  : MyCreditsWidget(),
            ),
            FFRoute(
              name: 'SetYourPin',
              path: 'setYourPin',
              builder: (context, params) => SetYourPinWidget(),
            ),
            FFRoute(
              name: 'userPreference1',
              path: 'userCommute',
              builder: (context, params) => UserPreference1Widget(),
            ),
            FFRoute(
              name: 'MatchingLoader',
              path: 'matchingLoader',
              builder: (context, params) => MatchingLoaderWidget(),
            ),
            FFRoute(
              name: 'Home',
              path: 'home',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'Home')
                  : HomeWidget(),
            ),
            FFRoute(
              name: 'modal_OfferRideSeats',
              path: 'modalOfferRideSeats',
              builder: (context, params) => ModalOfferRideSeatsWidget(),
            ),
            FFRoute(
              name: 'MeetingPoints',
              path: 'meetingPoints',
              builder: (context, params) => MeetingPointsWidget(),
            ),
            FFRoute(
              name: 'HomeCopy',
              path: 'homeCopy',
              builder: (context, params) => params.isEmpty
                  ? NavBarPage(initialPage: 'HomeCopy')
                  : HomeCopyWidget(),
            ),
            FFRoute(
              name: 'LiveTracking',
              path: 'liveTracking',
              builder: (context, params) => LiveTrackingWidget(),
            ),
            FFRoute(
              name: 'userPreference2',
              path: 'userPreference2',
              builder: (context, params) => UserPreference2Widget(),
            ),
            FFRoute(
              name: 'Details14Destination',
              path: 'details14Destination',
              builder: (context, params) => Details14DestinationWidget(),
            ),
            FFRoute(
              name: 'Status1',
              path: 'Status1',
              builder: (context, params) => Status1Widget(),
            ),
            FFRoute(
              name: 'Status2',
              path: 'Status2',
              builder: (context, params) => Status2Widget(),
            ),
            FFRoute(
              name: 'Status3',
              path: 'Status3',
              builder: (context, params) => Status3Widget(),
            ),
            FFRoute(
              name: 'CommuteSuccess',
              path: 'CommuteSuccess',
              builder: (context, params) => CommuteSuccessWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.extraMap.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, [
    bool isList = false,
  ]) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder: PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).transitionsBuilder,
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}
