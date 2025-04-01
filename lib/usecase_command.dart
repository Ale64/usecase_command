library usecase_command;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:functional_listener/functional_listener.dart';
import 'package:quiver/core.dart';
import 'package:stack_trace/stack_trace.dart';

import 'error_filters.dart';

export 'error_filters.dart';
export 'package:functional_listener/functional_listener.dart';

part './flutter_command.dart';
part './async_command.dart';
part './mock_command.dart';
part './sync_command.dart';
part './undoable_command.dart';
part './command_builder.dart';
part './usecase_command_async.dart';
part './usecase_command_sync.dart';

abstract class UsecaseCommand<TUsecase extends Object, TParam, TResult> extends Command<TParam, TResult> {
  UsecaseCommand({
    required super.initialValue,
    required super.restriction,
    required super.ifRestrictedExecuteInstead,
    required super.includeLastResultInCommandResults,
    required super.noReturnValue,
    required super.notifyOnlyWhenValueChanges,
    required super.errorFilter,
    required super.name,
    required super.noParamValue,
  });

  TUsecase? _usecase;

  void call([TParam? param]) => execute(param);

  UsecaseCommand<TUsecase, TParam, TResult> setUsecase(TUsecase usecase) {
    _usecase = usecase;
    return this;
  }

  static UsecaseCommand<TUsecase, void, void> createSyncNoParamNoResult<TUsecase extends Object>(
    void Function(TUsecase) action, {
    ValueListenable<bool>? restriction,
    void Function()? ifRestrictedExecuteInstead,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandSync<TUsecase, void, void>(
      funcNoParam: action,
      initialValue: null,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead != null ? (_) => ifRestrictedExecuteInstead() : null,
      includeLastResultInCommandResults: false,
      noReturnValue: true,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: true,
    );
  }

  static UsecaseCommand<TUsecase, TParam, void> createSyncNoResult<TUsecase extends Object, TParam>(
    void Function(TUsecase, TParam) action, {
    ValueListenable<bool>? restriction,
    ExecuteInsteadHandler<TParam>? ifRestrictedExecuteInstead,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandSync<TUsecase, TParam, void>(
      func: action,
      initialValue: null,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead,
      includeLastResultInCommandResults: false,
      noReturnValue: true,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: false,
    );
  }

  static UsecaseCommand<TUsecase, void, TResult> createSyncNoParam<TUsecase extends Object, TResult>(
    TResult Function(TUsecase) func, {
    required TResult initialValue,
    ValueListenable<bool>? restriction,
    void Function()? ifRestrictedExecuteInstead,
    bool includeLastResultInCommandResults = false,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandSync<TUsecase, void, TResult>(
      funcNoParam: func,
      initialValue: initialValue,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead != null ? (_) => ifRestrictedExecuteInstead() : null,
      includeLastResultInCommandResults: includeLastResultInCommandResults,
      noReturnValue: false,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: true,
    );
  }

  static UsecaseCommand<TUsecase, TParam, TResult> createSync<TUsecase extends Object, TParam, TResult>(
    TResult Function(TUsecase, TParam) func, {
    required TResult initialValue,
    ValueListenable<bool>? restriction,
    ExecuteInsteadHandler<TParam>? ifRestrictedExecuteInstead,
    bool includeLastResultInCommandResults = false,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandSync<TUsecase, TParam, TResult>(
      func: func,
      initialValue: initialValue,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead,
      includeLastResultInCommandResults: includeLastResultInCommandResults,
      noReturnValue: false,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: false,
    );
  }

  static UsecaseCommand<TUsecase, void, void> createAsyncNoParamNoResult<TUsecase extends Object>(
    Future<void> Function(TUsecase) action, {
    ValueListenable<bool>? restriction,
    void Function()? ifRestrictedExecuteInstead,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandAsync<TUsecase, void, void>(
      funcNoParam: action,
      initialValue: null,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead != null ? (_) => ifRestrictedExecuteInstead() : null,
      includeLastResultInCommandResults: false,
      noReturnValue: true,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: true,
    );
  }

  static UsecaseCommand<TUsecase, TParam, void> createAsyncNoResult<TUsecase extends Object, TParam>(
    Future<void> Function(TUsecase, TParam) action, {
    ValueListenable<bool>? restriction,
    ExecuteInsteadHandler<TParam>? ifRestrictedExecuteInstead,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandAsync<TUsecase, TParam, void>(
      func: action,
      initialValue: null,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead,
      includeLastResultInCommandResults: false,
      noReturnValue: true,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: false,
    );
  }

  static UsecaseCommand<TUsecase, void, TResult> createAsyncNoParam<TUsecase extends Object, TResult>(
    Future<TResult> Function(TUsecase) func, {
    required TResult initialValue,
    ValueListenable<bool>? restriction,
    void Function()? ifRestrictedExecuteInstead,
    bool includeLastResultInCommandResults = false,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandAsync<TUsecase, void, TResult>(
      funcNoParam: func,
      initialValue: initialValue,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead != null ? (_) => ifRestrictedExecuteInstead() : null,
      includeLastResultInCommandResults: includeLastResultInCommandResults,
      noReturnValue: false,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: true,
    );
  }

  static UsecaseCommand<TUsecase, TParam, TResult> createAsync<TUsecase extends Object, TParam, TResult>(
    Future<TResult> Function(TUsecase, TParam) func, {
    required TResult initialValue,
    ValueListenable<bool>? restriction,
    ExecuteInsteadHandler<TParam>? ifRestrictedExecuteInstead,
    bool includeLastResultInCommandResults = false,
    ErrorFilter? errorFilter,
    bool notifyOnlyWhenValueChanges = false,
    String? debugName,
  }) {
    return UsecaseCommandAsync<TUsecase, TParam, TResult>(
      func: func,
      initialValue: initialValue,
      restriction: restriction,
      ifRestrictedExecuteInstead: ifRestrictedExecuteInstead,
      includeLastResultInCommandResults: includeLastResultInCommandResults,
      noReturnValue: false,
      errorFilter: errorFilter,
      notifyOnlyWhenValueChanges: notifyOnlyWhenValueChanges,
      name: debugName,
      noParamValue: false,
    );
  }
}
