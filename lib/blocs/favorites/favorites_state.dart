part of 'favorites_bloc.dart';

class FavoritesState extends Equatable {
  final Set<int> favoriteIds;

  const FavoritesState({this.favoriteIds = const {}});

  bool isFavorite(int id) => favoriteIds.contains(id);

  @override
  List<Object> get props => [favoriteIds];
}
