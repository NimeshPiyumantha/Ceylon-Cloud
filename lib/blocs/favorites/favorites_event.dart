part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleFavorite extends FavoritesEvent {
  final int itemId;
  ToggleFavorite(this.itemId);
  @override
  List<Object> get props => [itemId];
}
