part of './flutter_command.dart';

class UsecaseCommandAsync<TUsecase extends Object, TParam, TResult> extends UsecaseCommand<TUsecase, TParam, TResult> {
  final Future<TResult> Function(TUsecase, TParam)? _func;
  final Future<TResult> Function(TUsecase)? _funcNoParam;

  UsecaseCommandAsync({
    Future<TResult> Function(TUsecase, TParam)? func,
    Future<TResult> Function(TUsecase)? funcNoParam,
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
  Future<TResult> _execute([TParam? param]) async {
    final usecase = _usecase;
    if (usecase == null) {
      throw ArgumentError('You must set the usecase before executing the command.');
    }

    TResult result;
    if (_noParamValue) {
      assert(_funcNoParam != null);
      if (Command.useChainCapture) {
        final completer = Completer<TResult>();
        Chain.capture(
          () => _funcNoParam!(usecase).then(completer.complete),
          onError: (error, chain) {
            if (completer.isCompleted) {
              return;
            }
            completer.completeError(error, chain);
          },
        );
        result = await completer.future;
      } else {
        result = await _funcNoParam!(usecase);
      }
    } else {
      assert(_func != null);
      assert(
        param != null || null is TParam,
        'You passed a null value to the command ${_name ?? ''} that has a non-nullable type as TParam',
      );
      if (Command.useChainCapture) {
        final completer = Completer<TResult>();
        Chain.capture(
          () => _func!(usecase, param as TParam).then(completer.complete),
          onError: (error, chain) {
            if (completer.isCompleted) {
              return;
            }
            completer.completeError(error, chain);
          },
        );
        result = await completer.future;
      } else {
        result = await _func!(usecase, param as TParam);
      }
    }
    return result;
  }
}
