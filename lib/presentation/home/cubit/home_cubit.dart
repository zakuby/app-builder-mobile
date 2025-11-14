import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing home page tab navigation
class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  /// Change the selected tab index
  void changeIndex(int index) {
    emit(index);
  }
}
