import 'package:bloc/bloc.dart';

class MyHomeCubit extends Cubit<int> {
  MyHomeCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}