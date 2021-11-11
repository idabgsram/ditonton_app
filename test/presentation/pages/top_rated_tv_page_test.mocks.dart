// Mocks generated by Mockito 5.0.16 from annotations
// in ditonton/test/presentation/pages/top_rated_tv_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:ditonton/presentation/bloc/top_rated_tv_bloc.dart' as _i2;
import 'package:flutter_bloc/flutter_bloc.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeTopRatedTVState_0 extends _i1.Fake implements _i2.TopRatedTVState {}

class _FakeStreamSubscription_1<T> extends _i1.Fake
    implements _i3.StreamSubscription<T> {}

/// A class which mocks [TopRatedTVBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockTopRatedTVBloc extends _i1.Mock implements _i2.TopRatedTVBloc {
  MockTopRatedTVBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.TopRatedTVState get state =>
      (super.noSuchMethod(Invocation.getter(#state),
          returnValue: _FakeTopRatedTVState_0()) as _i2.TopRatedTVState);
  @override
  _i3.Stream<_i2.TopRatedTVState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i2.TopRatedTVState>.empty())
          as _i3.Stream<_i2.TopRatedTVState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i2.TopRatedTVEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i2.TopRatedTVEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<
      _i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>> transformEvents(
          _i3.Stream<_i2.TopRatedTVEvent>? events,
          _i4.TransitionFunction<_i2.TopRatedTVEvent, _i2.TopRatedTVState>?
              transitionFn) =>
      (super.noSuchMethod(
              Invocation.method(#transformEvents, [events, transitionFn]),
              returnValue:
                  Stream<_i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>>.empty())
          as _i3.Stream<
              _i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>>);
  @override
  void emit(_i2.TopRatedTVState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i2.TopRatedTVEvent>(
          _i4.EventHandler<E, _i2.TopRatedTVState>? handler,
          {_i4.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<_i2.TopRatedTVState> mapEventToState(_i2.TopRatedTVEvent? event) =>
      (super.noSuchMethod(Invocation.method(#mapEventToState, [event]),
              returnValue: Stream<_i2.TopRatedTVState>.empty())
          as _i3.Stream<_i2.TopRatedTVState>);
  @override
  void onTransition(
          _i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>?
              transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i3.Stream<
      _i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>> transformTransitions(
          _i3.Stream<_i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>>?
              transitions) =>
      (super.noSuchMethod(
              Invocation.method(#transformTransitions, [transitions]),
              returnValue:
                  Stream<_i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>>.empty())
          as _i3.Stream<
              _i4.Transition<_i2.TopRatedTVEvent, _i2.TopRatedTVState>>);
  @override
  _i3.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>);
  @override
  _i3.StreamSubscription<_i2.TopRatedTVState> listen(
          void Function(_i2.TopRatedTVState)? onData,
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
              returnValue: _FakeStreamSubscription_1<_i2.TopRatedTVState>())
          as _i3.StreamSubscription<_i2.TopRatedTVState>);
  @override
  void onChange(_i4.Change<_i2.TopRatedTVState>? change) =>
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
