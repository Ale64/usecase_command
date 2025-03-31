part of './flutter_command.dart';

class UsecaseCommandSync<TUsecase extends Object, TParam, TResult> extends UsecaseCommand<TUsecase, TParam, TResult> {
  final TResult Function(TUsecase, TParam)? _func;
  final TResult Function(TUsecase)? _funcNoParam;

  @override
  ValueListenable<bool> get isExecuting {
    assert(false, "isExecuting isn't supported by synchronous commands");
    return ValueNotifier<bool>(false);
  }

  UsecaseCommandSync({
    TResult Function(TUsecase, TParam)? func,
    TResult Function(TUsecase)? funcNoParam,
    required super.initialValue,
    required super.restriction,
    required super.ifRestrictedExecuteInstead,
    required super.includeLastResultInCommandResults,
    required super.noReturnValue,
    required super.errorFilter,
    required super.notifyOnlyWhenValueChanges,
    required super.name,
    required super.noParamValue,
  })  : _func = func,
        _funcNoParam = funcNoParam;

  @override
  TResult _execute([TParam? param]) {
    final usecase = _usecase;
    if (usecase == null) {
      throw ArgumentError('You must set the usecase before executing the command.');
    }

    if (_noParamValue) {
      assert(_funcNoParam != null);
      return _funcNoParam!(usecase);
    } else {
      assert(_func != null);
      assert(
        param != null || null is TParam,
        'You passed a null value to the command ${_name ?? ''} that has a non-nullable type as TParam',
      );
      return _func!(usecase, param as TParam);
    }
  }
}
