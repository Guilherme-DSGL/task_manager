import 'package:task_manager/utils/result.dart';

extension ResultCast<T> on Result<T> {
  Ok<T> get asOk => this as Ok<T>;

  Error get asError => this as Error<T>;
}
