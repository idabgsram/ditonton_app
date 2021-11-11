// Mocks generated by Mockito 5.0.16 from annotations
// in ditonton/test/presentation/pages/watchlist_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:ditonton/presentation/bloc/watchlist_movies_bloc.dart' as _i4;
import 'package:ditonton/presentation/bloc/watchlist_tv_bloc.dart' as _i2;
import 'package:flutter_bloc/flutter_bloc.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeWatchlistTVState_0 extends _i1.Fake implements _i2.WatchlistTVState {
}

class _FakeStreamSubscription_1<T> extends _i1.Fake
    implements _i3.StreamSubscription<T> {}

class _FakeWatchlistMoviesState_2 extends _i1.Fake
    implements _i4.WatchlistMoviesState {}

/// A class which mocks [WatchlistTVBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistTVBloc extends _i1.Mock implements _i2.WatchlistTVBloc {
  MockWatchlistTVBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WatchlistTVState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeWatchlistTVState_0()) as _i2.WatchlistTVState);
  @override
  _i3.Stream<_i2.WatchlistTVState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.WatchlistTVState>.empty())
          as _i3.Stream<_i2.WatchlistTVState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i2.WatchlistTVEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i2.WatchlistTVEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<
      _i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>> transformEvents(
          _i3.Stream<_i2.WatchlistTVEvent>? events,
          _i5.TransitionFunction<_i2.WatchlistTVEvent, _i2.WatchlistTVState>?
              transitionFn) =>
      (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue:
                  Stream<_i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>>.empty())
          as _i3.Stream<
              _i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>>);
  @override
  void emit(_i2.WatchlistTVState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i2.WatchlistTVEvent>(
          _i5.EventHandler<E, _i2.WatchlistTVState>? handler,
          {_i5.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<_i2.WatchlistTVState> mapEventToState(
          _i2.WatchlistTVEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i2.WatchlistTVState>.empty())
          as _i3.Stream<_i2.WatchlistTVState>);
  @override
  void onTransition(
          _i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<
      _i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>> transformTransitions(
          _i3.Stream<_i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>>?
              transitions) =>
      (super.noSuchMethod(
              Invocation.method(#transformTransitions, [transitions]),
              returnValue:
                  Stream<_i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>>.empty())
          as _i3.Stream<
              _i5.Transition<_i2.WatchlistTVEvent, _i2.WatchlistTVState>>);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.StreamSubscription<_i2.WatchlistTVState> listen(
          void Function(_i2.WatchlistTVState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue: _FakeStreamSubscription_1<_i2.WatchlistTVState>())
          as _i3.StreamSubscription<_i2.WatchlistTVState>);
  @override
  void onChange(_i5.Change<_i2.WatchlistTVState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}

/// A class which mocks [WatchlistMoviesBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockWatchlistMoviesBloc extends _i1.Mock
    implements _i4.WatchlistMoviesBloc {
  MockWatchlistMoviesBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.WatchlistMoviesState get state => (super.noSuchMethod(
      Invocation.getter(#state),
      returnValue: _FakeWatchlistMoviesState_2()) as _i4.WatchlistMoviesState);
  @override
  _i3.Stream<_i4.WatchlistMoviesState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i4.WatchlistMoviesState>.empty())
          as _i3.Stream<_i4.WatchlistMoviesState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i4.WatchlistMoviesEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i4.WatchlistMoviesEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>
      transformEvents(
              _i3.Stream<_i4.WatchlistMoviesEvent>? events,
              _i5.TransitionFunction<_i4.WatchlistMoviesEvent,
                      _i4.WatchlistMoviesState>?
                  transitionFn) =>
          (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue:
                  Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>.empty()) as _i3
              .Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>);
  @override
  void emit(_i4.WatchlistMoviesState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i4.WatchlistMoviesEvent>(
          _i5.EventHandler<E, _i4.WatchlistMoviesState>? handler,
          {_i5.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<_i4.WatchlistMoviesState> mapEventToState(
          _i4.WatchlistMoviesEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i4.WatchlistMoviesState>.empty())
          as _i3.Stream<_i4.WatchlistMoviesState>);
  @override
  void onTransition(
          _i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>
      transformTransitions(
              _i3.Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>?
                  transitions) =>
          (super.noSuchMethod(
                  Invocation.method(#transformTransitions, [transitions]),
                  returnValue:
                      Stream<_i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>.empty())
              as _i3.Stream<
                  _i5.Transition<_i4.WatchlistMoviesEvent, _i4.WatchlistMoviesState>>);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.StreamSubscription<_i4.WatchlistMoviesState> listen(
          void Function(_i4.WatchlistMoviesState)? onData,
          {Function? onError,
          void Function()? onDone,
          bool? cancelOnError}) =>
      (super.noSuchMethod(
              Invocation.method(#listen, [
                onData
              ], {
                #onError: onError,
                #onDone: onDone,
                #cancelOnError: cancelOnError
              }),
              returnValue:
                  _FakeStreamSubscription_1<_i4.WatchlistMoviesState>())
          as _i3.StreamSubscription<_i4.WatchlistMoviesState>);
  @override
  void onChange(_i5.Change<_i4.WatchlistMoviesState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
