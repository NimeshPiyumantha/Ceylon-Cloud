part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Items> items;

  ProductLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class ProductError extends ProductState {
  final CustomException customException;

  ProductError(this.customException);

  @override
  List<Object> get props => [customException];
}
