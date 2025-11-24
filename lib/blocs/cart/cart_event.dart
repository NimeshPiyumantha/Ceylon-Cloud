part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddToCart extends CartEvent {
  final Items item;
  AddToCart(this.item);
  @override
  List<Object> get props => [item];
}

class RemoveFromCart extends CartEvent {
  final Items item;
  RemoveFromCart(this.item);
  @override
  List<Object> get props => [item];
}

class UpdateCartQuantity extends CartEvent {
  final Items item;
  final int change; // +1 or -1
  UpdateCartQuantity(this.item, this.change);
  @override
  List<Object> get props => [item, change];
}

class ClearCart extends CartEvent {}
