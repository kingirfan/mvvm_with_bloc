import 'package:flutter_bloc/flutter_bloc.dart';

enum BottomNavEvent { home, category, favorite, settings }

class BottomNavBloc extends Bloc<BottomNavEvent, int> {
  BottomNavBloc() : super(0) {
    on<BottomNavEvent>((event, emit) {
      emit(BottomNavEvent.values.indexOf(event));
    });
  }
}