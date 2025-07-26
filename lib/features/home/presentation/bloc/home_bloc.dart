import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/features/home/presentation/bloc/home_event.dart';
import 'package:my_app/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadWelcomeMessage>(_onLoadWelcomeMessage);
  }

  void _onLoadWelcomeMessage(
      LoadWelcomeMessage event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // شبیه‌سازی دریافت داده
      await Future.delayed(const Duration(seconds: 1));
      emit(const HomeLoaded(
          message: "This is a sample welcome message from API"));
    } catch (e) {
      emit(const HomeError(message: "Failed to load welcome message"));
    }
  }
}