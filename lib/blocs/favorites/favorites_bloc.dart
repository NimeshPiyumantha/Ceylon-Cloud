import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(const FavoritesState()) {
    on<ToggleFavorite>((event, emit) {
      final updatedIds = Set<int>.from(state.favoriteIds);
      if (updatedIds.contains(event.itemId)) {
        updatedIds.remove(event.itemId);
      } else {
        updatedIds.add(event.itemId);
      }
      emit(FavoritesState(favoriteIds: updatedIds));
    });
  }
}
